<template>
  <div id="gradient" ref="panel"></div>
</template>


<script>
export default {
  name: "gradient",
  props: ["pPosition", "panel"],
  methods: {
    percentage: function (partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
    initPanel: function () {
      let panelPositions = [];
      let pWidth = this.$refs.panel.offsetWidth;
      var w = window.innerWidth;
      let pPercentage = this.percentage(pWidth, w);

      panelPositions.push({ name: "panel", width: pPercentage });

      this.$emit("mounted", panelPositions);
    },
  },
  mounted() {
    this.initPanel();
  },
};
</script>

<style lang="scss">
#gradient {
  width: 100vw;
  --border: 3px;
  position: relative;
}
</style>
