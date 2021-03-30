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
      <p>pPosition: {{ pPosition }}</p>
      <p>pTarget: {{ pTarget }}</p>
      <p>sumWidth: {{ sumWidth }}</p>
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
        @menuToggleClicked="panelsMenu = arguments[0]"
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
        :class="{ slideOn: sliderIndicator, shrinkTwo: panelsMenu }"
        :pPosition="pPosition"
        :panel="panel"
        @mounted="assignPanelWidth(index, ...arguments)"
      ></component>
    </div>
    <div class="foot" v-if="Math.abs(mPos) > 20 && false">
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
  name: "panelsExpanded.vue",
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
      ],
      targets: [],
      sumWidth: 0,
      panelsMenu: false,
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
    assignPanelWidth: function (index, panelPositions) {
      if (panelPositions) {
        //Variable that contains either nothing or all the
        let panel = [];
        panel = panelPositions.filter((t) =>
          t.name == "panel" ? true : false
        );

        //Update the width of this current parent panel
        this.panels[index].width = panel[0].width;

        //Find any subpanels in this parent panel
        let subPanel = panelPositions.filter((t) =>
          t.name == "subPanel" ? true : false
        );

        //Make sure subtargets actually exist
        if (subPanel.length > 0) {
          //Update the width of all subpanels to this parent panel
          this.panels[index].subTargets.forEach((t) => {
            t.width = subPanel[0].width;
          });
        }
      }
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

        if (t.subTargets) {
          //check subtargets
          let arrayes = t.subTargets;
          t.subTargets = this.calcTargets(arrayes, sumWidth);
        }

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
      //pick the panel to magnetic scroll back to
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

      var getMemory = function (tarID) {
        //get the panel in the array that has the id passed
        //Using this to get the next panel and the previous panel so we can consider them when calculating the closest because if we dont it fucks up and only consideres the subpanels of the closest mainpanel when we are starting to get close to the next panel
        if (tar[tarID]) {
          return tar[tarID];
        } else return null;
      };

      if (tar.length) {
        //If there exists some targets

        let closestMain = nearestTargetInArray(tar);
        let closestSub = {};
        let combinedArray = [];

        //get the next and the last panel in the array and store them in a memory object
        let memory = {
          past: getMemory(closestMain.id - 1),
          future: getMemory(closestMain.id + 1),
        };

        //Add the main panel thats currently closest
        combinedArray.push(closestMain);

        var addClosestSubpanel = function (tar) {
          //function to add closest subpanel in main panel
          combinedArray.push(closestMain);
          if (tar) {
            if (tar.subTargets && tar.subTargets.length > 0) {
              closestSub = nearestTargetInArray(tar.subTargets);
              combinedArray.push(closestSub);
            }
          }
        };

        //Add the current main panel the last and the next into the combined array object
        addClosestSubpanel(closestMain);
        addClosestSubpanel(memory.past);
        addClosestSubpanel(memory.future);

        //Find the closest target among all the targets in the combined array
        let closest = nearestTargetInArray(combinedArray);

        //if position is within threshhold og target make it the assigned target
        //diff is the distance between position and target
        let diff = pos - closest.position;
        if (Math.abs(diff) > 30) {
          //If the distance to target is greater than threshold then dont magetise towards target
          //pass ;
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
        //if the expanded panel has been scrolled back to the start
        //this.$emit("panelPositionInactive", true);
      }

      //Update target position to closest panel when scrolling
      this.pickTarget();

      //Deflate towards Target
      let diff = this.pTarget - this.pPosition;
      this.pPosition += diff * 0.05;

      //Min max range check
      this.pPosition = _.clamp(this.pPosition, -this.sumWidth, 0);

      window.requestAnimationFrame(this.panelScroll);
    },
  },
  mounted() {
    this.panelScroll();
    this.targets = this.updateTargets();
  },
};
</script>

<style lang="scss">
@use '@/css' as *;

.slider2 input {
  position: fixed;
  top: 0px;
  left: 5em;
  width: 70vw;
}

#expanded {
  --panelHeadHeight: 15vh;
  position: relative;
  background: $bg;
  transition: 0.4s;
  display: grid;
  grid-template-rows: var(--panelHeadHeight) 1fr;
  height: 100vh;
  position: absolute;
  left: -10vw;
}

.slideOn {
  transform: scale(0.8);
}

.shrinkTwo {
  transform: scale(0.7);
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
 