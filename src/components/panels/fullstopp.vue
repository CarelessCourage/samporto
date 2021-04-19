<template>
  <div id="fullstopp" ref="panel">
    <div class="container">
      <h2 class="source" @click="distSubStyle(0)">
        sourceissource.com {{ panel.subTargets[1].position }}
      </h2>
      <div class="content">
        <div
          v-for="(par, index) in panel.subTargets"
          :key="index"
          id="subPanel"
          :style="
            'opacity:' + distSubStyle(index) * 0.01 + ';' + borderNone(index)
          "
        >
          <p>{{ panel.content }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "fullstopp",
  props: ["pPosition", "panel"],
  methods: {
    borderNone: function (index) {
      let dist = this.distSubStyle(index);
      let result = "";
      if (dist < 50) {
        result = "border-left: none; border-right: none;";
      }
      return result;
    },
    distSubStyle: function (index) {
      let result = 0;

      let pos = Math.abs(this.panel.subTargets[index].position);
      let scroll = Math.abs(this.pPosition);
      let diff = Math.abs(pos - scroll);
      let dist = 100 - diff;

      if (dist < 0) {
        result = 0;
      } else {
        result = dist;
      }

      return result;
    },
    percentage: function (partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
    initPanel: function () {
      let panelPositions = [];
      let pWidth = this.$refs.panel.offsetWidth;
      let spWidth = document.querySelector("#subPanel").offsetWidth;
      var w = window.innerWidth;
      let pPercentage = this.percentage(pWidth, w);
      let spPercentage = this.percentage(spWidth, w);

      panelPositions.push({ name: "panel", width: pPercentage });
      panelPositions.push({ name: "subPanel", width: spPercentage });

      this.$emit("mounted", panelPositions);
    },
  },
  mounted() {
    this.initPanel();
    window.addEventListener("resize", () =>
      setTimeout(() => this.initPanel(), 1000)
    );
  },
};
</script>

<style lang="scss">
@use '@/css' as *;

#fullstopp {
  --border: 3px;
  --subPanelWidth: 60vw;

  padding: 20vw;
  padding-top: 10vh;

  .container {
    position: relative;
  }
  .source {
    margin: 0px;
    left: calc(50vw - (var(--subPanelWidth) / 2));
    position: sticky;
    width: var(--subPanelWidth);
    padding: 2em;
    padding-top: 1em;
    padding-bottom: 1em;
    box-sizing: border-box;
    text-align: left;
    border: var(--border) solid $fg;
  }
  .content {
    display: flex;
    justify-content: center;
    align-items: center;

    div {
      margin: 0px;
      margin-top: calc(var(--border) * -1);
      font-size: 1.5em;
      width: var(--subPanelWidth);
      height: 15em;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: left;
      border: var(--border) solid $fg;

      transition: border 0.8s;
      box-sizing: border-box;
      padding-bottom: 2em;
      p {
        width: 80%;
      }
    }
  }
}

@media only screen and (max-width: 600px) {
  #fullstopp {
    --subPanelWidth: 90vw;
    padding: 5vw;
    margin-top: 2em;
    .container {
      position: relative;
    }
    .source {
      padding: 0em;
      border: none;
    }
    .content {
      margin-top: 2em;
      div {
        height: auto;
        border: none;
        p {
          width: 100%;
        }
      }
    }
  }
}
</style>
