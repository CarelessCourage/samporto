<template>
  <div class="head" id="panelHead" v-if="true">
    <div class="fixed">
      <div class="xBtn" v-if="!down" @click="$emit('close')"></div>
      <div class="percentage" :style="'width: ' + sliderPercent + '%;'"></div>
      <div
        class="panelIndicator"
        v-if="sliderIndicator"
        :style="
          'left: ' +
          panelPercent.position +
          '%; width: ' +
          panelPercent.width +
          '%;'
        "
      >
        <fittyComponent
          :positionPercent="panelPercent.position"
          :indicatorPanel="indicatorPanel"
          :sliderActive="slider"
          :numberOfPanels="targets.length"
        />
      </div>
      <div
        class="sliderIndicator"
        :style="'width: ' + indicatorPercent + '%;'"
        v-if="sliderIndicator"
      ></div>
      <div class="slider">
        <input
          type="range"
          min="0"
          :max="maxWidth"
          v-model="slider"
          id="myRange"
          @mouseup="upX()"
          @mousedown="downX()"
        />
      </div>
    </div>
  </div>
</template>


<script>
import fittyComponent from "./fittyComponent.vue";

export default {
  name: "panelControl",
  components: {
    fittyComponent,
  },
  props: ["sumWidth", "position", "targets", "sliderIndicator", "sliderID"],
  data() {
    return {
      slider: 0,
      indicatorPanel: { position: 300, width: 100 },
      down: false,
    };
  },
  watch: {
    sliderID: function (sliderID) {
      let targets = this.targets;
      let current = targets[sliderID];
      this.indicatorPanel = current;
    },
    slider: function (slider) {
      let pos = Math.abs(slider);
      let targets = this.targets;
      let current = targets.reduce((a, b) => {
        return Math.abs(b.position - pos) < Math.abs(a.position - pos) ? b : a;
      });
      this.indicatorPanel = current;
      this.$emit("indicatorPanel", current);
    },
  },
  computed: {
    maxWidth: function () {
      let sum = Math.abs(this.sumWidth);
      return sum;
    },
    panelPercent: function () {
      let sum = this.sumWidth;
      let pos = Math.abs(this.indicatorPanel.position);
      let width = this.indicatorPanel.width;

      let rPos = this.percentage(pos, sum);
      let rWidth = this.percentage(width, sum);

      return { position: rPos, width: rWidth };
    },
    indicatorPercent: function () {
      let sum = this.sumWidth;
      let pos = Math.abs(this.slider);
      return this.percentage(pos, sum);
    },
    sliderPercent: function () {
      let sum = this.sumWidth;
      let pos = Math.abs(this.position);
      return this.percentage(pos, sum);
    },
  },
  methods: {
    percentage: function (partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
    upX: function () {
      this.$emit("sliderToggle", false);

      //Send slider yo position
      let sliderPos = -this.slider;
      this.$emit("gsapTo", {
        duration: 0.3,
        pPosition: sliderPos,
      });
      this.down = false;
    },
    downX: function () {
      this.$emit("sliderToggle", true);
      this.down = true;
    },
  },
  mounted() {
    this.getHeadHeight;
  },
};
</script>

<style lang="scss" scoped>
@use '@/css' as *;

#panelHead {
  animation-name: opacity;
  animation-duration: 0.2s;
  animation-timing-function: ease-out;
  animation-delay: 0.5s;
  animation-fill-mode: backwards;
}

.panelIndicator {
  position: absolute;
  background-color: rgba($fg, 0.5);
  right: 0vw;
  width: 10vw;
  height: 100%;
  transition: 0.8s;
  z-index: 2;
  animation-name: opacity;
  animation-duration: 0.8s;
  #fittyComponent {
    position: absolute;
  }
}

@keyframes opacity {
  0% {
    opacity: 0;
  }
  100% {
    opacity: 1;
  }
}

.sliderIndicator {
  z-index: 9;
  position: absolute;
  width: 100vw;
  height: 100%;
  &::after {
    content: "";
    position: absolute;
    right: 0px;
    width: 0.2em;
    height: 100%;
    background: $fg;
  }
}
.percentage {
  background-color: rgba($fg, 0.2);
  width: 100vw;
  height: 100%;
  z-index: 1;
}

.lol {
  position: fixed;
  z-index: 999;
  bottom: 0em;
  left: 5em;
  pointer-events: none;
}

.slider {
  z-index: 8;
  opacity: 0;
  position: fixed;
  //background: red;
  width: 100%;
  input {
    width: 100vw;
    height: var(--panelHeadHeight);
  }
}
.fixed {
  position: fixed;
  top: 0px;
  left: 0px;
  width: 100vw;
  height: var(--panelHeadHeight);
  display: flex;
  align-items: center;
  border-bottom: var(--border) solid $fg;
  border-top: var(--border) solid $fg;
}

.head {
  position: relative;
  cursor: pointer;
}

.xBtn {
  position: fixed;
  z-index: 99;
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
    background: $fg;
    top: 40%;
    left: 0px;
    transform: rotateZ(45deg);
  }
  &::after {
    transform: rotateZ(-45deg);
  }
}
</style>
