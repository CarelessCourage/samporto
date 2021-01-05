<template>
  <div id="expanded" class="container" :style="'left: ' + pPosition + 'vw;'">
    <div
      v-if="false"
      style="
        position: fixed;
        top: 50;
        left: 50px;
        z-index: 10;
        text-align: left;
      "
      @click="combineArrays"
    >
      <p>mPosition: {{ pPosition }}</p>
      <p>mScroll: {{ mScroll }}</p>
      <p>mTarget: {{ pTarget }}</p>
      <p>sliderID: {{ sliderID }}</p>
    </div>
    <div class="slider2" v-if="false">
      <input
        type="range"
        :min="-sumWidth"
        max="0"
        v-model="pPosition"
        id="myRange"
      />
    </div>
    <panelControl
      v-if="true"
      :targets="targets"
      :position="pPosition"
      :sumWidth="sumWidth"
      :sliderIndicator="sliderIndicator"
      :sliderID="sliderID"
      @close="$emit('close')"
      @gsapTo="gsapTo(...arguments)"
      @sliderToggle="sliderIndicator = arguments[0]"
      @indicatorPanel="indicatorPanel = arguments[0]"
    />
    <div class="panels">
      <panelMenu
        :targets="targets"
        :slider="slider"
        :sliderIndicator="sliderIndicator"
        :pPosition="pPosition"
        :indicatorPanel="indicatorPanel"
        @gsapTo="gsapTo(...arguments)"
        @hoverLi="
          sliderIndicator = arguments[0];
          sliderID = arguments[1];
        "
      />
      <component
        v-for="(panel, index) in panels"
        :key="index"
        :is="panel.component"
        class="panel"
        :class="{ slideOn: slider }"
        :pPosition="pPosition"
        :panel="panel"
        @mounted="assignWidth(index, ...arguments)"
      ></component>
    </div>
    <div class="foot" v-if="Math.abs(mPos) > 20">
      <h1>{{ getCurrentPageComp + 1 }}/{{ targets.length }}</h1>
    </div>
  </div>
</template>


<script>
var _ = require("lodash");
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
gsap.registerPlugin(ScrollTrigger);

import intro from "./panels/intro.vue";
import fullstopp from "./panels/fullstopp.vue";
import images from "./panels/images.vue";
import gradient from "./panels/gradient.vue";
import panelControl from "./panelControl.vue";
import panelMenu from "./panelMenu.vue";

export default {
  name: "expanded",
  props: ["mScroll", "mPos"],
  components: {
    intro,
    fullstopp,
    images,
    gradient,
    panelControl,
    panelMenu,
  },
  data() {
    return {
      slider: false,
      indicatorPanel: 0,
      sliderIndicator: false,
      sliderID: 0,
      pPosition: 0,
      pTarget: -0,
      panels: [
        {
          title: "God is God",
          component: "intro",
          width: 100,
          subTargets: [],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "For geet God",
          component: "images",
          width: 100,
          subTargets: [
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "for god es",
          component: "fullstopp",
          width: 100,
          subTargets: [
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "God is God",
          component: "intro",
          width: 100,
          subTargets: [],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "For geet God",
          component: "images",
          width: 100,
          subTargets: [
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "for god es",
          component: "fullstopp",
          width: 100,
          subTargets: [
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
            { width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "God is God",
          component: "intro",
          width: 100,
          subTargets: [],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "For geet God",
          component: "images",
          width: 100,
          subTargets: [
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "For geet God",
          component: "images",
          width: 100,
          subTargets: [
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "For geet God",
          component: "images",
          width: 100,
          subTargets: [
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "For geet God",
          component: "images",
          width: 100,
          subTargets: [
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "For geet God",
          component: "images",
          width: 100,
          subTargets: [
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "For geet God",
          component: "images",
          width: 100,
          subTargets: [
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
            { url: require("../assets/Fleur.png"), width: 5 },
          ],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
      ],
      targets: [],
      sumWidth: 0,
      currentPanel: 0,
    };
  },
  computed: {
    getCurrentPageComp: function () {
      let pos = Math.abs(this.pPosition);
      let current = this.targets.reduce((a, b) => {
        return Math.abs(b.position - pos) < Math.abs(a.position - pos) ? b : a;
      });
      var index = current.id;
      return index;
    },
  },

  methods: {
    slideToggle: function (bool) {
      this.slider = bool;
    },
    gsapTo: function (obj) {
      gsap.to(this, obj);
    },
    assignWidth: function (index, panelPositions) {
      if (panelPositions) {
        let panel = panelPositions.filter((t) =>
          t.name == "panel" ? true : false
        );

        this.panels[index].width = panel[0].width;

        let subPanel = panelPositions.filter((t) =>
          t.name == "subPanel" ? true : false
        );

        this.panels[index].subTargets.forEach((t) => {
          t.width = subPanel[0].width;
        });
      }

      //subPanel.forEach((t) => {
      //  this.panels.push(t);
      //});
    },
    print: function () {
      console.log("sumWidth: ", this.sumWidth);
    },
    calcTargets: function (array, startWidth) {
      let sumWidth = startWidth;
      let calcSubTarg = array.map((st) => {
        st.position = sumWidth;
        sumWidth += st.width;
        return st;
      });
      return calcSubTarg;
    },
    updateTargets: function () {
      const panels = this.panels;
      let sumWidth = 0;
      let calcTarg = panels.map((t, index) => {
        t.position = sumWidth;
        t.id = index;
        //if (t.subTargets) {
        //check subtargets
        let arrayes = t.subTargets;
        t.subTargets = this.calcTargets(arrayes, sumWidth);
        //}
        sumWidth += t.width;
        return t;
      });
      this.sumWidth = sumWidth - 100;
      return calcTarg;
    },
    combineArrays: function () {
      let tar = this.targets;
      let arrayeee = [];
      tar.forEach((t) => {
        t.subTargets.forEach((st) => {
          arrayeee.push(st);
        });
      });
      this.targets.push(...arrayeee);
    },
    pickTarget: function () {
      let pos = Math.abs(this.pPosition);
      let tar = this.targets;
      let newTar = this.pPosition;

      var nearestTargetInArray = function (arr) {
        return arr.reduce((a, b) => {
          return Math.abs(b.position - pos) < Math.abs(a.position - pos)
            ? b
            : a;
        });
      };

      if (tar.length) {
        let closestMain = nearestTargetInArray(tar);
        let closestSub = {};
        let combinedArray = [];

        combinedArray.push(closestMain);

        if (closestMain.subTargets.length > 0) {
          closestSub = nearestTargetInArray(closestMain.subTargets);
          combinedArray.push(closestSub);
        }

        let closest = nearestTargetInArray(combinedArray);

        //console.log("nearest: ", closest);

        let diff = pos - closest.position;

        if (Math.abs(diff) > 30) {
          //something ;
        } else {
          newTar = -closest.position;
        }

        this.pTarget = newTar;
      }
    },
    panelScroll: function () {
      //Update position on scroll
      this.pPosition += -this.mScroll;

      if (this.pPosition < -2) {
        this.$emit("panelPositionInactive", false);
      } else {
        this.$emit("panelPositionInactive", true);
      }

      //Update target position to closest panel when scrolling
      this.pickTarget();

      //Deflate towards Target
      let diff = this.pTarget - this.pPosition;
      this.pPosition += diff * 0.05;

      //Min max range check
      this.pPosition = _.clamp(this.pPosition, -this.sumWidth, 0);
      //console.log("sumWidth: ", this.sumWidth);

      window.requestAnimationFrame(this.panelScroll);
    },
  },
  mounted() {
    this.panelScroll();
    this.targets = this.updateTargets();
    //console.log(this.targets);
  },
};
</script>

<style lang="scss">
.slider2 input {
  position: fixed;
  top: 0px;
  left: 5em;
  width: 70vw;
}

#expanded {
  --panelHeadHeight: 15vh;
  position: relative;
  background: white;
  transition: 0.4s;
  display: grid;
  grid-template-rows: var(--panelHeadHeight) 1fr;
  height: 100vh;
  position: absolute;
  left: -10vw;
}

.slideOn {
  transform: scale(0.9);
}

.panels {
  position: relative;
  display: flex;
  flex-direction: row;
}

.panel {
  min-width: 100vw;
  position: relative;
  transition: 0.8s;
  transform-origin: left center;
}

.foot {
  position: fixed;
  bottom: 2em;
  right: 2em;
  z-index: 999;
  display: flex;
  justify-content: flex-end;
  align-items: flex-end;
  h1 {
    font-size: 5em;
    left: 0;
    text-align: right;
    position: relative;
  }
}
</style>
 