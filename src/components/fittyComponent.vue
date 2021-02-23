<template>
  <div id="fittyComponent" :style="'width: ' + remainingPercent() + 'vw;'">
    <div class="metaData" :class="{ on: metaData }">
      <p :style="'width: ' + fittyWidth + 'px;'">
        text: {{ indicatorPanel.id + 1 }}/{{ numberOfPanels }}
      </p>
    </div>
    <span id="fitty" :class="{ on: metaData }">
      {{ indicatorPanel.title }}
    </span>
  </div>
</template>


<script>
import fitty from "fitty";

export default {
  name: "fittyComponent",
  props: [
    "sliderActive",
    "positionPercent",
    "indicatorPanel",
    "numberOfPanels",
  ],
  data() {
    return {
      fittyWidth: 1000,
      $_fitty: undefined,
      metaData: false,
      options: {
        minSize: 16,
        maxSize: 130,
        multiLine: false,
      },
    };
  },
  watch: {
    sliderActive: function () {
      this.updateFitty;
      setTimeout(this.updateFitty, 100);
    },
  },
  methods: {
    updateFitty: function () {
      if (document.getElementById("fitty")) {
        this.fittyWidth = document
          .getElementById("fitty")
          .getBoundingClientRect().width;
        fitty.fitAll();
        this.metaData = true;
      }
    },
    remainingPercent: function () {
      let val = 100 - this.positionPercent;
      return val;
    },
  },
  destroyed() {
    //this.$_fitty.unsubscribe();
  },
  mounted() {
    //console.log("el: ", this.$el);
    this.$_fitty = fitty("#fitty", this.options);
  },
};
</script>

<style lang="scss" scoped>
#fittyComponent {
  width: 40vw;
}

span {
  opacity: 0;
  text-align: left;
  font-weight: bold;
  text-transform: uppercase;
  line-height: 1em;
  &.on {
    opacity: 1;
  }
}

.metaData {
  opacity: 0;
  display: flex;
  justify-content: center;
  transition: opacity 0.4s;
  &.on {
    opacity: 1;
  }
  p {
    //text-transform: uppercase;
    width: 800px;
    max-height: 1em;
    font-weight: bold;
    line-height: 1em;
    margin-bottom: -5px;
    margin-top: 5px;
    opacity: 0.5;
  }
}
</style>
