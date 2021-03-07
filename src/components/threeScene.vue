<template>
  <div class="ThreeTest">
    <div class="tempBtn" v-if="true">
      <p @click="test()">click</p>
      <p @click="lol()">in</p>
    </div>
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
      <div class="sheet" :class="{ open: expanded }"></div>
      <div id="canvas2"></div>
    </div>
  </div>
</template>

<script>
//import preload from "preloadjs";
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
          pos: [{ duration: 0, x: 0, y: 1, z: -1 }],
          rot: [{ duration: 0, x: -1, y: -0, z: -0 }],
        },
        default: {
          pos: { duration: 0.3, x: 1 },
          rot: { duration: 0.3, x: -0.5, y: -0.5, z: -0.3 },
        },
        expanded: {
          pos: { duration: 0.3, x: 0 },
          rot: { duration: 0.3, x: -0, y: -0, z: -0 },
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
    test: function () {
      var imageLength = this.images.length - 1;

      let tl = gsap.timeline();
      tl.to(this, { duration: 0, position: -imageLength - 5 });

      let targets = this.gPositions.preload;
      this.moveGroupSequence(targets);
    },
    lol: function () {
      let tl = gsap.timeline();
      tl.to(this, { duration: 3, position: 0.0 });
    },
    mesh: function (imgUrl, index, uniforms) {
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
    init: function (canvas, opacity, hole) {
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

        let mesh = this.mesh(el.img, i, uniforms);
        mesh.cursor = "pointer";

        var changeCenteredPosition = (i) => {
          //put the group in the middle for the expanded view
          let pos = Math.round(this.position);
          let ri = Math.round(i);
          if (pos < ri) {
            this.scrollSpeed = -0.2;
          } else if (pos > ri) {
            this.scrollSpeed = 0.2;
          } else if (pos == ri) {
            uniforms.expanded.value = this.expanded;
            this.binaryMoveGroup(false, true);
          }
        };

        mesh.on("click", function () {
          changeCenteredPosition(-i);
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
        let rotation = g.rotation;
        let position = g.position;

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
        let target = this.gPositions.default;
        this.moveGroup(target);
      } else {
        let target = this.gPositions.expanded;
        this.moveGroup(target, true);
      }
    },
    initMoveGroup: function () {
      //Initialising Three.js scenes
      let canvas = document.getElementById("canvas");
      this.g.group1 = this.init(canvas, 0.0, false);
      let canvas2 = document.getElementById("canvas2");
      this.g.group2 = this.init(canvas2, 0.5, true);

      //Rotate and move the meshes
      this.binaryMoveGroup(false, false);
    },
  },
  mounted() {
    this.preload();
    //Scroll feedback
    window.addEventListener("wheel", (e) => {
      let delta = 0;
      let amount = 1 * 0.04;
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
.tempBtn {
  background: rgb(0, 0, 0);
  color: white;
  width: 5em;
  padding: 2em;
  position: absolute;
  z-index: 100;
  bottom: 0px;
  cursor: pointer;
  &:hover {
    opacity: 0.5;
  }
}

.titles {
  position: absolute;
  top: 20vw;
  left: 10vw;
  max-height: 10vh;
  z-index: 10;
  pointer-events: none;
  //transition: top 0.8s ease-in-out;
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

.sheet {
  background-color: rgb(255, 225, 225);
  height: 100vh;
  width: 0vw;
  position: relative;
  z-index: 5;
  transition: 0.4s ease-in-out;
  &.open {
    width: 100vw;
  }
}

.n {
  position: absolute;
  top: 100px;
  background: blue;
  height: 10px;
  width: 80px;
}

.webGL {
  position: relative;
  //background: pink;
  width: 100vw;
  height: 100vh;
}

#canvas,
#canvas2 {
  height: 100vh;
  width: 100vw;
  position: absolute;
  z-index: 6;
  top: 0px;
  left: 0px;
  //background: red;
}
#canvas2 {
  //background: red;
  left: 0px;
  z-index: 4;
}

.box {
  height: 6em;
  width: 6em;
  background: red;
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