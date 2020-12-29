<template>
  <div class="ThreeTest">
    <div class="titles" :class="{ expanded: expanded }">
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
    <div class="webGL">
      <div id="canvas"></div>
      <div class="sheet" :class="{ open: expanded }"></div>
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
  props: ["expanded"],
  data() {
    return {
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
      position: -1,
    };
  },
  methods: {
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
        material.needsUpdate = true;
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
      console.log(interaction);

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
          let pos = Math.round(this.position);
          let ri = Math.round(i);
          if (pos < ri) {
            this.scrollSpeed = -0.2;
          } else if (pos > ri) {
            this.scrollSpeed = 0.2;
          } else if (pos == ri) {
            uniforms.expanded.value = this.expanded;
            this.moveGroup(group, false, true);
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
    moveGroup: function (group, bool, refresh) {
      let stay = false;
      stay = bool;

      let expanded = this.expanded;

      if (refresh) {
        expanded = !this.expanded;
        this.$emit("expand");
      }

      let rotation = group.rotation;
      let position = group.position;

      if (!expanded || stay) {
        gsap.to(rotation, {
          duration: 0.3,
          x: -0.5,
          y: -0.5,
          z: -0.3,
        });

        gsap.to(position, {
          duration: 0.3,
          x: 1,
        });
      } else {
        gsap.to(rotation, {
          duration: 0.3,
          x: -0,
          y: -0,
          z: -0,
        });
        gsap.to(position, {
          duration: 0.3,
          x: 0,
        });
      }
    },
  },
  mounted() {
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
    this.inertia();

    //Initialising Three.js scenes
    let canvas = document.getElementById("canvas");
    let group1 = this.init(canvas, 0.0, false);

    let canvas2 = document.getElementById("canvas2");
    let group2 = this.init(canvas2, 0.5, true);

    console.log(group1, group2);

    //Rotate and move the meshes
    this.moveGroup(group1, true, false);
    this.moveGroup(group2, false, false);

    //group2.position.x = 0;
  },
};
</script>

<style scoped lang="scss">
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
  &.expanded {
    //left: 5vw;
    //top: 120vh;
  }
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
</style>