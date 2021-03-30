<template>
  <div class="ThreeTest">
    <div v-if="false">
      <p>{{ position }}</p>
      <p>{{ touch.yStart }}</p>
      <p>{{ touch.distanceFromStart }}</p>
    </div>
    <transition name="title">
      <div
        class="titles"
        :class="{ expanded: expanded }"
        v-if="!navigation && false"
      >
        <h1 v-if="Math.round(position) >= -0">The unborn are a</h1>
        <h1 v-if="Math.round(position) == -1">God is god</h1>
        <h1 v-if="Math.round(position) == -2">This is</h1>
        <h1 v-if="Math.round(position) == -3">Get mad</h1>
        <h1 v-if="Math.round(position) == -4">fol</h1>
        <h1 v-if="Math.round(position) <= -5">About</h1>
        <div class="debug" v-if="false">
          <p>position: {{ position }}</p>
          <p>scrollSpeed: {{ scrollSpeed }}</p>
        </div>
      </div>
    </transition>
    <div class="webGL">
      <div id="canvas"></div>
      <div id="sheets" :class="{ open: expanded }">
        <div class="sheet"></div>
        <div class="sheet"></div>
      </div>
      <div id="canvas2"></div>
    </div>
  </div>
</template>

<script>
import * as Three from "three";
import { Interaction } from "three.interaction";
import gsap from "gsap";

import fragment from "./shader/fragment.glsl";
import vertex from "./shader/vertex.glsl";

export default {
  name: "ThreeTest",
  props: ["expanded", "navigation"],
  data() {
    return {
      g: {
        group1: null,
        group2: null,
      },
      gPositions: {
        preload: {
          pos: [{ dur: 0, x: 0, y: 1, z: -1 }],
          rot: [{ dur: 0, x: -1, y: -0, z: -0 }],
        },
        default: {
          pos: { dur: 0.4, x: 1, y: 0, z: 0 },
          rot: { dur: 0.4, x: -0.5, y: -0.5, z: -0.3 },
        },
        expanded: {
          pos: { dur: 0.4, x: 0, y: 0, z: 0 },
          rot: { dur: 0.4, x: -0, y: -0, z: -0 },
        },
      },
      preloader: {
        total: 0,
        cached: 0,
        complete: false,
      },
      images: [
        {
          img: require("../assets/lorem.jpg"),
        },
        {
          img: require("../assets/sam.jpg"),
        },
        {
          img: require("../assets/lucky.jpg"),
        },
        {
          img: require("../assets/coffee.png"),
        },
        {
          img: require("../assets/no.jpg"),
        },
      ],
      scrollSpeed: 0,
      position: -0,
      touch: {
        test: 0,
        yStart: 0,
        distanceFromStart: 0,
        last: 0,
        temp: false,
      },
    };
  },
  methods: {
    responsiveGroupPosition: function () {
      function clamp(num, min, max) {
        return num <= min ? min : num >= max ? max : num;
      }

      function percentage(partialValue, totalValue) {
        return (100 * partialValue) / totalValue;
      }

      let width = window.innerWidth;

      let min = 600;
      let max = 1400;
      let range = max - min;
      let clampedWidth = clamp(width, 500, 1600);
      let normalizedWidth = clampedWidth - min;
      let per = percentage(normalizedWidth, range);
      let desimalPer = clamp(per, 0, 100) / 100;

      this.gPositions.default.pos.x = desimalPer;
    },
    initialPreloadPosition: function () {
      var imageLength = this.images.length - 1;

      let tl = gsap.timeline();
      tl.to(this, { duration: 0, position: -imageLength - 5 });

      let targets = this.gPositions.preload;
      this.moveGroupSequence(targets);
    },
    createMesh: function (imgUrl, index, uniforms) {
      //Creates a mesh plane with the assigned image and uniforms
      var imageJPG = document.createElement("img");
      imageJPG.src = imgUrl;

      const material = new Three.ShaderMaterial({
        side: Three.DoubleSide,
        wireframe: false,
        transparent: true,
        vertexShader: vertex,
        fragmentShader: fragment,
        uniforms,
      });

      let that = this;

      (function main(frame) {
        if (that.preloader.complete) {
          material.needsUpdate = true;
        }

        material.uniforms.time.value = frame / 2;

        material.uniforms.scroll.value = that.scrollSpeed;
        requestAnimationFrame(main);
      })(0);

      material.uniforms.texture1.value = new Three.Texture(imageJPG);
      material.uniforms.texture1.value.needsUpdate = true;

      let geo = new Three.PlaneBufferGeometry(1.5, 1, 20, 20);
      let mesh = new Three.Mesh(geo, material);

      (function repeat() {
        let dist = Math.min(Math.abs(-that.position - index), 1);
        dist = 1 - dist ** 2;
        material.uniforms.inFocus.value = dist;

        let focusScale = 1 + 0.1 * dist;

        mesh.position.y = -(index * 1.2) - that.position * 1.2;
        mesh.scale.set(focusScale, focusScale, focusScale);
        requestAnimationFrame(repeat);
      })(0);

      return mesh;
    },
    assembleMesh: function (canvas, opacity, hole) {
      //use createMesh to make a mesh for each image in image array.
      //assemble them to a group to easily move them rogheter and add group to the three.js scene

      /* eslint-disable */

      let container = canvas;

      let camera = new Three.PerspectiveCamera(
        60,
        container.clientWidth / container.clientHeight,
        0.01,
        10
      );
      camera.position.z = 2;

      let scene = new Three.Scene();

      let renderer = new Three.WebGLRenderer({ antialias: true, alpha: true });
      renderer.setClearColor(0x000000, 0);

      const interaction = new Interaction(renderer, scene, camera);
      //console.log(interaction);

      const group = new Three.Group();
      this.images.forEach((el, i) => {
        var uniforms = {
          hole: {
            value: hole,
          },
          expanded: {
            value: this.expanded,
          },
          scroll: {
            type: "f",
            value: 0,
          },
          opacity: {
            type: "f",
            value: opacity,
          },
          inFocus: {
            type: "f",
            value: 0,
          },
          time: {
            type: "f",
            value: 0,
          },
          texture1: {
            type: "t",
            value: null,
          },
        };

        let mesh = this.createMesh(el.img, i, uniforms);
        mesh.cursor = "pointer";

        var clickedMesh = (i) => {
          //put the mesh in the middle vertically
          //or open expanded state
          let pos = Math.round(this.position);
          let ri = Math.round(i);
          if (pos < ri) {
            //if the clicked mesh is above the centered mesh
            //add some scroll value to send it into the centered view
            this.scrollSpeed = -0.2;
          } else if (pos > ri) {
            //if the clicked mesh is bellow the centered mesh
            //add some scroll value to send it into the centered view
            this.scrollSpeed = 0.2;
          } else if (pos == ri) {
            //if the clicked mesh is in the center
            //initiate expanded state with this mesh
            uniforms.expanded.value = this.expanded;
            this.binaryMoveGroup(false, true);
          }
        };

        mesh.on("click", function () {
          clickedMesh(-i);
        });

        group.add(mesh);
      });

      scene.add(group);

      renderer.setSize(container.clientWidth, container.clientHeight);
      container.appendChild(renderer.domElement);
      renderer.render(scene, camera);

      (function refresher() {
        renderer.render(scene, camera);
        requestAnimationFrame(refresher);
      })(0);

      let that = this;

      function frameRefresh() {
        let width = window.innerWidth;
        let height = window.innerHeight;

        camera.aspect = width / height;
        camera.updateProjectionMatrix();

        renderer.setSize(container.clientWidth, container.clientHeight);

        that.responsiveGroupPosition();
        that.moveGroup(that.gPositions.default, false);
      }

      window.addEventListener("resize", frameRefresh);

      return group;
      /* eslint-enable */
    },
    inertia: function () {
      this.position += -this.scrollSpeed;
      this.scrollSpeed *= 0.85;
      this.rounded = Math.round(this.position);
      let diff = this.rounded - this.position;
      this.position += diff * 0.05;

      this.scrollCorrection();

      window.requestAnimationFrame(this.inertia);
    },
    scrollCorrection: function () {
      let pos = this.position;
      let array = this.images.length + 0.5;
      let floor = 0 + 0.5;
      if (pos < -array) {
        this.position = -array;
        this.scrollSpeed -= 0.1;
      } else if (pos > floor) {
        this.position = floor;
        this.scrollSpeed += 0.1;
      }
    },
    touchScroll: function () {
      let that = this;
      const body = document.body;
      body.addEventListener("touchstart", function (event) {
        that.touch.yStart = event.touches[0].clientY;
      });
      body.addEventListener("touchmove", function (event) {
        let yNew = event.touches[0].clientY;
        that.touch.distanceFromStart = yNew - that.touch.yStart;

        let normalisation = that.touch.distanceFromStart / 8000;

        if (normalisation < 0) {
          //we are touching upward
          console.log("upwards");
        } else {
          //we are touching upwards
          console.log("downwards");
        }

        if (that.touch.last < normalisation) {
          //console.log("last less");
          //that.touch.yStart = event.touches[0].clientY;
          //that.position += normalisation;
        } else {
          //console.log("last more");
          that.position += normalisation;
        }

        that.touch.last = normalisation;

        //that.touch.test += normalisation;

        //console.log("touch: ", newnew / 8000);
      });
    },
    preload: function () {
      //console.log(preload);
      var imageFiles = this.images;
      var images = [];
      let that = this;
      imageFiles.forEach((ImgFile, index) => {
        let imageLoaded = function () {
          that.preloader.cached += 1;
          if (that.preloader.cached == imageFiles.length) {
            that.preloader.complete = true;
          }
        };
        let loadImage = function (url) {
          var image = new Image();
          image.addEventListener("load", imageLoaded, false);
          image.src = url;
          return image;
        };
        images[index] = loadImage(ImgFile.img);
      });
    },
    moveGroupSequence: function (targets) {
      //Does the same as moveGroup but it lets you chain togheter multiple targets using GSAP target
      //Define move function
      var move = (g) => {
        let rotation = g.rotation;
        let position = g.position;

        var tlRot = gsap.timeline();
        var tlPos = gsap.timeline();

        targets.rot.forEach((tar) => {
          tlRot.to(rotation, tar);
        });

        targets.pos.forEach((tar) => {
          tlPos.to(position, tar);
        });
      };

      move(this.g.group1);
      move(this.g.group2);
    },
    moveGroup: function (target, single) {
      //Define move function
      var move = (g) => {
        //=========Reset and Fix target object
        delete target.pos.parent;
        delete target.rot.parent;

        function resetDuration(target) {
          target.pos.duration = target.pos.dur;
          target.rot.duration = target.rot.dur;
        }

        resetDuration(target);

        //=========Setup
        let rotation = g.rotation;
        let position = g.position;

        //=========Execute
        gsap.to(rotation, target.rot);
        gsap.to(position, target.pos);
      };

      //Move groups
      if (single) {
        //If sigle is passed as true then we will only move the top group.
        move(this.g.group1);
      } else {
        //If its not move both
        move(this.g.group1);
        move(this.g.group2);
      }
    },
    binaryMoveGroup: function (bool, refresh) {
      let stay = false;
      stay = bool;

      let expanded = this.expanded;

      if (refresh) {
        //open expanded view
        expanded = !this.expanded;
        this.$emit("expand");
      }

      if (!expanded || stay) {
        //Set the group position either to the default position or the expanded view position depending on the expanded state
        let _default = this.gPositions.default;
        this.moveGroup(_default);
      } else {
        let _expanded = this.gPositions.expanded;

        //console.log("ex: ", _expanded.pos.x, _expanded.pos.y);
        this.moveGroup(_expanded, true);
      }
    },
    initMoveGroup: function () {
      //Initialising Three.js scenes
      let canvas = document.getElementById("canvas");
      this.g.group1 = this.assembleMesh(canvas, 0.0, false);
      let canvas2 = document.getElementById("canvas2");
      this.g.group2 = this.assembleMesh(canvas2, 0.5, true);

      //set initial group position
      this.initialPreloadPosition();

      this.responsiveGroupPosition();
      //this.moveGroup(this.gPositions.default, false);
    },
    groupEnterAnimation: function () {
      function ease(target, ease) {
        target.pos.ease = ease;
        target.rot.ease = ease;
      }
      function changeDuration(target, time) {
        target.pos.duration = time;
        target.rot.duration = time;
      }

      let master = gsap.timeline({ defaults: { ease: "power2.out" } });
      master.to(this, { duration: 3, position: 0.0 });

      let _default = this.gPositions.default;
      changeDuration(_default, 2);
      ease(_default, "power3.inOut");
      let defaultTime = _default.pos.duration;

      let _expanded = this.gPositions.expanded;

      changeDuration(_expanded, 2);
      let expandedTime = _expanded.pos.duration;

      function move(g, target, time) {
        let tl = gsap.timeline({ defaults: { ease: "power3.out" } });

        let rotation = g.rotation;
        let position = g.position;

        tl.to(rotation, target.rot);
        tl.to(position, target.pos, "-=" + time);

        return tl;
      }

      //If its not move both
      master.add(move(this.g.group1, _expanded, expandedTime));
      master.add(
        move(this.g.group2, _expanded, expandedTime),
        "-=" + expandedTime
      );

      //If its not move both
      master.add(
        move(this.g.group1, _default, defaultTime),
        "-=" + expandedTime / 2
      );
      master.add(
        move(this.g.group2, _default, defaultTime),
        "-=" + defaultTime
      );

      //Rotate and move the meshes
      //this.binaryMoveGroup(false, false);
    },
  },
  watch: {
    "preloader.complete": function (e) {
      //console.log("log: ");
      if (e) {
        this.groupEnterAnimation();
      }
    },
  },
  mounted() {
    this.preload();
    //Scroll feedback
    window.addEventListener("wheel", (e) => {
      let delta = 0;
      let amount = this.$store.state.scrollAmount;
      if (!this.expanded) {
        if (e.deltaY > 0) {
          delta = amount;
        } else if (e.deltaY < 0) {
          delta = -amount;
        }
        this.scrollSpeed += delta;
      }
    });

    //Doesnt work yet
    this.touchScroll();

    this.inertia();

    //Rotate and move the meshes
    this.initMoveGroup();
  },
};
</script>

<style scoped lang="scss">
@use '@/css' as *;

.titles {
  position: absolute;
  top: 20vw;
  left: 10vw;
  max-height: 10vh;
  z-index: 10;
  pointer-events: none;
  transition: 0.8s ease-in-out;
  transition-delay: 0.4s;

  h1 {
    width: 5em;
    line-height: 0.8em;
  }
  p {
    width: 40em;
    margin: 0px;
    padding-left: 10px;
    text-align: left;
  }
}

#sheets {
  background: $fg-spice;
  height: 100vh;
  width: 0vw;
  position: relative;
  z-index: 5;
  transition: 0.4s ease-in-out;
  &.open {
    width: 100vw;
    .sheet {
      width: 100%;
    }
  }
  .sheet {
    position: absolute;
    top: 0px;
    background: $bg-spice;
    width: 0vw;
    height: 100vh;
    transition: 0.6s ease-in-out;
    &:nth-of-type(1) {
      background: $mg;
      transition: 0.5s ease-in-out;
    }
  }
}

.webGL {
  position: relative;
  width: 100vw;
  height: 100vh;
}

#canvas {
  height: 100vh;
  width: 100vw;
  position: absolute;
  z-index: 6;
  top: 0px;
  left: 0px;
}

#canvas2 {
  @extend #canvas;
  left: 0px;
  z-index: 4;
}

.title-enter-active,
.title-leave-active {
  transition: transform 0.5s;
}
.title-enter,
.title-leave-to {
  transform: translateX(-50em);
}
</style>