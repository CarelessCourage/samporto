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
      <p>pPosition: {{ pPos }}</p>
      <p v-if="false">mScroll: {{ mScroll }}</p>
      <p v-if="false">mTarget: {{ mTarget }}</p>
      <p v-if="false">shiftLimit: {{ shiftLimit }}</p>
    </div>
    <navigation
      @navClick="navigation = !navigation"
      :navigation="navigation"
      :expanded="expanded"
    />
    <div
      class="page"
      :class="{ engaged: panels, shift: navigation }"
      :style="'top: ' + mPosition + 'vh;'"
    >
      <threeScene
        class="section"
        @expand="expanded = !expanded"
        :expanded="expanded"
        :navigation="navigation"
      />
      <div class="section lol" v-if="expanded">
        <panelsExpanded
          :mScroll="mScroll"
          :mPos="mPosition"
          @positionMove="pPositionMove"
          @close="togglePanel(0)"
          @panelPositionInactive="panelActivty"
        />
      </div>
    </div>
  </div>
</template>

<script>
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
gsap.registerPlugin(ScrollTrigger);
var _ = require("lodash");

import threeScene from "./components/threeScene.vue";
import panelsExpanded from "./components/panelsExpanded.vue";
import navigation from "./components/navigation.vue";

export default {
  name: "App",
  components: {
    threeScene,
    panelsExpanded,
    navigation,
  },
  data() {
    return {
      check: 0,
      expanded: false,
      panels: false,
      mScroll: 0,
      mPosition: 0,
      mTarget: 0,
      pPos: 0,
      shiftLimit: -25,
      panelPositionInactive: false,
      yStart: 0,
      navigation: false,
      touch: {
        touchStartY: 0,
        touchMoveY: {
          now: 0,
          last: 0,
        },
        flick: false,
        touchDirection: 0,
      },
    };
  },
  watch: {
    expanded: function () {
      this.navigation = false;
    },
  },
  methods: {
    pPositionMove: function (value) {
      this.pPos = value;
    },
    panelActivty: function (bool) {
      this.panelPositionInactive = bool;
    },
    togglePanel: function (target) {
      gsap.to(this, {
        duration: 0.8,
        mPosition: target,
      });
    },
    changeShiftLimit: function () {
      //change shift limit so its closer to the current position than half away.
      if (this.mPosition > -50) {
        this.shiftLimit = -25;
      } else {
        this.shiftLimit = -75;
      }
    },
    magneticScroll: function () {
      if (this.mPosition < -99.5 && !this.panelPositionInactive) {
        //pass ;
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
    touchScroll: function () {
      let that = this;
      let touch = this.touch;
      let moveY = touch.touchMoveY.now;
      let lastY = touch.touchMoveY.last;
      let startY = touch.touchStartY;

      const body = document.body;

      function executePositionMove() {
        if (that.mPosition > -90 || that.pPos > -10) {
          return true;
        } else {
          return false;
        }
      }

      body.addEventListener("touchstart", function (event) {
        if (that.expanded) {
          start(event);
        }
      });

      body.addEventListener("touchmove", function (event) {
        if (that.expanded) {
          move(event);
        }
      });

      body.addEventListener("touchend", function () {
        if (that.expanded) {
          flick();
        }
      });

      function start(event) {
        touch.touchMoveY.flick = true;
        setTimeout(function () {
          touch.touchMoveY.flick = false;
        }, 150);

        startY = event.touches[0].clientY;
        moveY = startY;
        lastY = startY;
      }

      function flick() {
        let dist = Math.abs(moveY - startY);
        // Test for flick.
        if (touch.touchMoveY.flick && dist > 0) {
          //has stopped
          let add = that.touch.touchDirection * 70;
          let p = _.clamp(that.mPosition + add, -100, 0);

          if (executePositionMove()) {
            gsap.to(that, {
              duration: 0.2,
              mPosition: p,
            });
          }
        }
      }

      function move(event) {
        let normalisation = 20;
        moveY = event.touches[0].clientY;
        let distanceFromStart = moveY - startY;

        if (moveY < startY) {
          that.touch.touchDirection = -1;
          //Check if touch is in an downward direction
          //-- needs to check this in order to get a vector to use when later checking if the direction has changed
          if (moveY < lastY) {
            //If touch is continuing in the same direction
            if (executePositionMove()) {
              that.mPosition += distanceFromStart / normalisation;
            }
          } else {
            //reset If touch is in a still position or new direction
            startY = event.touches[0].clientY;
          }
        } else {
          that.touch.touchDirection = 1;
          //Check if touch is in an upward direction
          //-- needs to check this in order to get a vector to use when later checking if the direction has changed
          if (moveY > lastY) {
            //Check if touch has changed direction
            if (executePositionMove()) {
              that.mPosition += distanceFromStart / normalisation;
            }
          } else {
            //reset If touch is in a still position or new direction
            startY = event.touches[0].clientY;
          }
        }

        lastY = moveY;
        touch.touchMoveY.active = false;
      }
    },
    getDoc: function () {
      fetch(
        "https://docs.googleapis.com/v1/documents/1yxpvWouM177KL3JHMPezILp3zPcw_k3y1Ca0SiIBl_Q"
      ).then((res) => {
        return res.json;
      });
    },
    scrollManager: function () {
      window.addEventListener("wheel", (e) => {
        //Takes scroll event and modifies the mScroll variable based on a global amount
        let delta = 0;
        let store = this.$store.state;
        let amount = store.scrollAmount * store.scrollMultiplier;
        if (this.expanded) {
          if (e.deltaY > 0) {
            delta = amount;
          } else if (e.deltaY < 0) {
            delta = -amount;
          }
          this.mScroll += delta;
          this.changeShiftLimit();
        }
      });

      let that = this;

      function detectTrackPad(e) {
        //Check whether the scroll is coming from a mouse wheel or a track pad
        var isTrackpad = false;
        let amount = 0.05;

        if (e.wheelDeltaY) {
          if (e.wheelDeltaY === e.deltaY * -3) {
            isTrackpad = true;
            amount = 0.005;
          }
        } else if (e.deltaMode === 0) {
          isTrackpad = true;
          amount = 0.005;
        }

        that.$store.dispatch("scrollDeltaChange", amount);
        return isTrackpad; //just to avoid error
      }

      document.addEventListener("mousewheel", detectTrackPad, false);
      document.addEventListener("DOMMouseScroll", detectTrackPad, false);
    },
  },
  mounted() {
    this.scrollManager();
    this.touchScroll();
    this.magneticScroll();
  },
};
</script>

<style lang="scss">
@use '@/css' as *;

.page {
  background: $bg;
  transition: transform 0.8s ease-in-out;
  &.shift {
    --marginTop: -8em;
    --marginRight: 8em;
    transform: translate(var(--marginTop), var(--marginRight));
  }
}

:root {
  --border: 3px;
}

.page {
  position: absolute;
  top: 0vh;
  &.engaged {
    top: -100vh;
  }
}

html {
  background: $fg;
  max-width: 100vw;
  max-height: 100vh;
  overflow-y: hidden;
  overflow-x: hidden;
}

#app {
  max-width: 100vw;
  position: fixed;
}

body {
  margin: 0px;
}
</style>
