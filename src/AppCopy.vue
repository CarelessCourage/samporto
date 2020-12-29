<template>
  <div id="app">
    <div v-if="true" style="position: absolute; top: 0; left: 0; z-index: 10">
      <p>Scroll: {{ scrollSpeed }}</p>
    </div>
    <div
      class="page"
      :class="{ engaged: panels }"
      :style="'top: ' + -30 + 'vh;'"
    >
      <threeScene
        class="section"
        @expand="expanded = !expanded"
        :expanded="expanded"
      />
      <div class="section lol" v-if="expanded">
        <expanded
          :expanded="expanded"
          @close="
            panels = false;
            this.scollSpeed = 0;
          "
        />
      </div>
    </div>
    <div class="UX_scrollSignal" v-if="false">
      <h1>Keep Scrolling</h1>
    </div>
  </div>
</template>

<script>
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
gsap.registerPlugin(ScrollTrigger);

import threeScene from "./components/threeScene.vue";
import expanded from "./components/expanded.vue";

export default {
  name: "App",
  components: {
    threeScene,
    expanded,
  },
  data() {
    return {
      check: 0,
      expanded: false,
      scrollSpeed: 0,
      position: 0,
      rounded: 0,
      panels: false,
      magneticScroll: 0,
      magneticPosition: 0,
    };
  },
  computed: {
    computeMagneticScroll2: function () {
      let scroll = this.scrollSpeed;
      let result = 0;
      result = scroll * 10000;

      let upperLimit = 0;
      let lowerLimit = 100;

      if (-result >= upperLimit) {
        result = 0;
      } else if (-result <= -lowerLimit) {
        result = lowerLimit;
      }

      return -result;
    },
    computeMagneticScroll: function () {
      let scroll = this.scrollSpeed;
      let result = 0;
      result = (scroll * 10000) / 2;
      return result;
    },
  },
  methods: {
    activatePanelScroll: function () {
      console.log("lolworks");
      gsap.to(".lol", {
        x: "-50vw",
        scrub: 1,
        ease: "linear",
        scrollTrigger: {
          trigger: ".lol",
          markers: true,
          start: "top 75%", //when top of herman passes 75% viewport height
          end: "bottom 25%", //when bottom of herman passes 25% viewport height

          //events: onEnter onLeave onEnterBack onLeaveBack
          toggleActions: "restart complete reverse reset",
          //options: play, pause, resume, reset, restart, complete, reverse,none
        },
      });
    },
    inertia: function () {
      this.position += -this.scrollSpeed;
      this.scrollSpeed *= 0.95;
      this.rounded = Math.round(this.position);
      let diff = this.rounded - this.position;
      this.position += diff * 0.05;
      window.requestAnimationFrame(this.inertia);
    },
    engagePanels: function (delta) {
      //let limit = 15;
      //let value = 0;
      //value += this.scrollSpeed * 100;
      console.log("Works: ", delta * 100);

      //setTimeout(() => {
      //  //if (value > limit) {
      //  //  this.panels = true;
      //  //}
      //  console.log(delta);
      //}, 3000);
    },
    magneticScroll: function (delta) {
      this.magneticScroll += delta;
      let scroll = this.magneticScroll;

      let pointOfNoReturn = 50;

      if (scroll >= pointOfNoReturn) {
        this.magneticScroll *= 0.85;
      } else {
        //result = 0;
      }
    },
  },
  mounted() {
    //this.activatePanelScroll();
    window.addEventListener("wheel", (e) => {
      let delta = 0;
      let amount = 1 * 0.04;
      if (this.expanded) {
        if (e.deltaY > 0) {
          delta = amount;
        } else if (e.deltaY < 0) {
          delta = -amount;
        }
        this.scrollSpeed += delta;
        this.magneticScroll(delta);
      }
    });
    //this.inertia();
  },
};
</script>

<style lang="scss">
.lol {
  position: absolute;
  top: 100vh;
  z-index: 7;
  transition: top 0.8s ease-in-out;
  &.engaged {
    top: 0px;
  }
}

.page {
  position: absolute;
  top: 0vh;
  transition: top 0.8s ease-in-out;
  &.engaged {
    top: -100vh;
  }
}

.UX_scrollSignal {
  height: 5em;
  transition: height 0.4s;
  max-height: 50em;
  width: 100%;
  background: white;
  position: fixed;
  z-index: 6;
  bottom: 0vh;
  p {
    margin: 0px;
  }
  h1 {
    margin: 0px;
    font-size: 10em;
    text-align: left;
    text-transform: uppercase;
  }
}
html {
  max-width: 100vw;
  max-height: 100vh;
  overflow-y: hidden;
  overflow-x: hidden;
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  max-width: 100vw;
  //max-height: 100vh;
  position: relative;
}
body {
  margin: 0px;
}
</style>
