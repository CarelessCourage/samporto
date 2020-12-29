<template>
  <div id="expanded" class="container" :style="'left: ' + pPosition + 'vw;'">
    <div
      v-if="true"
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
    </div>
    <div class="head" @click="$emit('close')" v-if="true">
      <div class="x"></div>
    </div>
    <div class="panels">
      <component
        v-for="(panel, index) in panels"
        :key="index"
        :is="panel.component"
        class="panel"
        :pPosition="pPosition"
        :panel="panel"
        @mounted="assignWidth(index, ...arguments)"
      ></component>
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
export default {
  name: "expanded",
  props: ["mScroll"],
  components: {
    intro,
    fullstopp,
  },
  data() {
    return {
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
          title: "",
          component: "fullstopp",
          width: 100,
          subTargets: [{ width: 5 }, { width: 5 }, { width: 5 }],
          content:
            " This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size. It also exerts some control over the alignment of items when they overflow the line. .container { This defines the alignment along the main axis. It helps distribute extra free space leftover when either all the flex items on a line are inflexible,",
        },
        {
          title: "",
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
      ],
      targets: [],
      sumWidth: 0,
    };
  },

  methods: {
    assignWidth: function (index, panelPositions) {
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

      //subPanel.forEach((t) => {
      //  this.panels.push(t);
      //});

      console.log("lol panel: ", this.panels);
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
      let calcTarg = panels.map((t) => {
        t.position = sumWidth;
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
      console.log("All targets: ", this.targets);
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
#expanded {
  position: relative;
  background: white;
  transition: 0.4s;
  display: grid;
  grid-template-rows: 15vh 1fr;
  height: 100vh;
  position: absolute;
  left: -10vw;
}
.panels {
  display: flex;
  flex-direction: row;
}

.panel {
  min-width: 100vw;
  position: relative;
}

.head {
  --border: 3px;
  border-bottom: var(--border) solid rgb(0, 0, 0);
  border-top: var(--border) solid rgb(0, 0, 0);
  display: flex;
  justify-content: flex-end;
  align-items: center;
  cursor: pointer;
  &:hover {
    background: red;
  }
  &:active {
    opacity: 0.5;
  }
}
.x {
  position: fixed;
  right: 10px;
  height: 5em;
  width: 5em;
  margin-right: 1.5em;
  &::before,
  &::after {
    content: "";
    position: absolute;
    height: 0.5em;
    width: 100%;
    background: black;
    top: 40%;
    left: 0px;
    transform: rotateZ(45deg);
  }
  &::after {
    transform: rotateZ(-45deg);
  }
}
</style>
