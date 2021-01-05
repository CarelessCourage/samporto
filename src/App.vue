<template>
  <div id="app">
    <div
      v-if="false"
      style="
        position: absolute;
        top: 50;
        left: 50px;
        z-index: 10;
        text-align: left;
      "
    >
      <p>mPosition: {{ mPosition }}</p>
      <p>mScroll: {{ mScroll }}</p>
      <p>mTarget: {{ mTarget }}</p>
      <p>shiftLimit: {{ shiftLimit }}</p>
      <p>cooldown: {{ cooldown }}</p>
    </div>
    <div
      class="page"
      :class="{ engaged: panels }"
      :style="'top: ' + mPosition + 'vh;'"
    >
      <threeScene
        class="section"
        @expand="expanded = !expanded"
        :expanded="expanded"
      />
      <div class="section lol" v-if="expanded">
        <expanded
          :mScroll="mScroll"
          :mPos="mPosition"
          @close="togglePanel(0)"
          @panelPositionInactive="panelActivty"
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
var _ = require("lodash");

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
      panels: false,
      mScroll: 0,
      mPosition: 0,
      mTarget: 0,
      shiftLimit: -25,
      cooldown: false,
      panelPositionInactive: false,
    };
  },
  watch: {
    shiftLimit: function () {
      //broken attempt to fix bug
      //this.cooldown = true;
      setTimeout(function () {
        //console.log("lolololol", this.cooldown);
        this.cooldown = false;
      }, 3000);
    },
  },
  methods: {
    panelActivty: function (bool) {
      this.panelPositionInactive = bool;
    },
    print: function (d) {
      console.log("inactive: " + d);
    },
    togglePanel: function (target) {
      gsap.to(this, {
        duration: 0.8,
        mPosition: target,
      });
    },
    cShiftLimit: function () {
      if (this.mPosition > -50) {
        this.shiftLimit = -25;
      } else {
        this.shiftLimit = -75;
      }
    },
    magneticScroll: function () {
      if (this.mPosition < -99.5 && !this.panelPositionInactive) {
        //console.log("mPosition is scroll locked"); ;
      } else {
        //update position with scroll values
        this.mPosition += -this.mScroll;
      }

      //slowly decrease scroll per frame
      this.mScroll *= 0.95;

      //if higher than middle change target
      if (this.mPosition <= this.shiftLimit) {
        this.mTarget = -100;
      } else {
        this.mTarget = 0;
      }

      //deflate position towards target
      let diff = this.mTarget - this.mPosition;
      this.mPosition += diff * 0.05;

      //Limit position so you dont scroll past the actual content
      this.mPosition = _.clamp(this.mPosition, -100, 0);

      //Update the function every animation frame
      window.requestAnimationFrame(this.magneticScroll);
    },
  },
  mounted() {
    window.addEventListener("wheel", (e) => {
      let delta = 0;
      let amount = 0.5;
      if (this.expanded) {
        if (e.deltaY > 0) {
          delta = amount;
        } else if (e.deltaY < 0) {
          delta = -amount;
        }
        this.mScroll += delta;
        this.cShiftLimit();
      }
    });
    this.magneticScroll();
  },
};
</script>

<style lang="scss">
:root {
  --border: 3px;
}

h1 {
  margin: 0px;
  text-align: left;
  font-size: 10em;
  text-transform: uppercase;
  font-weight: bold;
  line-height: 0.8em;
}

h2 {
  margin: 0px;
  text-align: left;
  font-size: 2em;
  font-weight: bold;
}

p {
  margin: 0px;
  text-align: left;
  font-size: 1.5em;
}

.lol {
  height: 100vh;
  z-index: 7;
  transition: top 0.8s ease-in-out;
  &.engaged {
    top: 0px;
  }
}

.page {
  position: absolute;
  top: 0vh;
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
  position: relative;
}
body {
  margin: 0px;
}
</style>
