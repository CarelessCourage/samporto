<template>
  <div class="panelMenu" @click="currentPosition()" ref="panels">
    <!-- Menu Button -->
    <div class="menuBtn" @click="menuToggleClicked">
      <div class="lines"></div>
    </div>
    <!-- Menu -->
    <div
      class="menuText"
      :class="{ off: !menuToggle }"
      ref="menuText"
      v-if="true"
    >
      <!-- Highlight Element -->
      <div
        :class="{ on: slider || sliderIndicator }"
        class="highlight"
        :style="
          'width: ' +
          highlight.width +
          'px; height: ' +
          highlight.height +
          'px; top: ' +
          highlight.top +
          'px; left: ' +
          highlight.left +
          'px;'
        "
      ></div>
      <!-- Panel List -->
      <ul class="main" ref="ulMain" :style="'top: ' + relativeScroll + 'px;'">
        <ul v-for="t in fTargets" :key="t.id" :id="t.id" class="title">
          <p
            @click="clickedLi(t.id)"
            @mouseover="hoverLi(true, t.id)"
            @mouseleave="hoverLi(false, t.id)"
            :class="{ current: current == t.id }"
          >
            {{ t.title }}
          </p>
          <li
            v-for="st in t.panels"
            :key="st.id"
            :id="st.id"
            class="p"
            :class="{ current: current == st.id }"
            @click="clickedLi(st.id)"
            @mouseover="hoverLi(true, st.id)"
            @mouseleave="hoverLi(false, st.id)"
          >
            <p>{{ st.title }}</p>
          </li>
        </ul>
      </ul>
    </div>
  </div>
</template>


<script>
export default {
  name: "panelMenu",
  props: [
    "targets",
    "slider",
    "indicatorPanel",
    "pPosition",
    "sliderIndicator",
  ],
  data() {
    return {
      menuToggle: false,
      index: 1,
      current: 0,
      fTargets: [],
      highlight: {
        width: 200,
        height: 50,
        left: 0,
        top: 0,
      },
    };
  },
  watch: {
    // whenever question changes, this function will run
    indicatorPanel: function () {
      this.index = this.indicatorPanel.id;
    },
    targets: function () {
      this.formatTargets();
    },
    index: function () {
      this.moveHighlight();
    },
    pPosition: function () {
      this.currentPosition();
    },
  },
  computed: {
    // a computed getter
    relativeScroll: function () {
      let pos = this.pPosition;

      //Get the width of the entire panel scroll
      let width = 0;
      if (this.$refs.panels) {
        width = this.$refs.panels.clientWidth;
      }

      //Get percentage of panelwide scroll
      let panelWidePercentage = this.percentage(pos, width);

      //Get the height of the meny summary
      let height = 0;
      if (this.$refs.ulMain) {
        height = this.$refs.ulMain.clientHeight;
      }

      //Get percentage of panelwide scroll
      var result = ((panelWidePercentage * 10) / 100) * height;

      return result;
    },
  },
  methods: {
    menuToggleClicked: function () {
      let toggle = this.menuToggle;
      if (toggle) {
        this.$store.commit("scrollMultiplierChange", 20);
      } else {
        this.$store.commit("scrollMultiplierChange", 40);
      }
      this.menuToggle = !this.menuToggle;

      this.$emit("menuToggleClicked", this.menuToggle);
    },
    percentage: function (partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
    currentPosition: function () {
      let pos = Math.abs(this.pPosition);
      let t = this.targets;
      let current = [{ id: 0 }];

      if (t.length) {
        current = t.reduce((a, b) => {
          return Math.abs(b.position - pos) < Math.abs(a.position - pos)
            ? b
            : a;
        });
      }

      this.current = current.id;
    },
    gsapTo: function (pos) {
      this.$emit("gsapTo", {
        duration: 0.3,
        pPosition: pos,
      });
    },
    clickedLi: function (id) {
      //Why no work?
      this.gsapTo(-this.targets[id].position);
    },
    hoverLi: function (bool, id) {
      this.$emit("hoverLi", bool, id);
      this.index = id;
    },
    moveHighlight: function () {
      let index = this.index;

      let li = document.getElementById(index);
      let parent = this.$refs.menuText;

      if ((li != null) & (parent != null)) {
        var parentRect = parent.getBoundingClientRect();
        var childRect = li.getBoundingClientRect();

        let topDist = Math.abs(parentRect.top - childRect.top);
        let leftDist = Math.abs(parentRect.x - childRect.x);

        let height = li.clientHeight;
        let width = li.clientWidth;
        let left = leftDist;
        let top = topDist;

        this.highlight = {
          width: width,
          height: height,
          left: left,
          top: top,
        };
      }
    },
    formatTargets: function () {
      let t = this.targets;

      let intro = t.filter((e) => {
        if (e.component == "intro") {
          return true;
        } else {
          return false;
        }
      });

      let notIntro = t.filter((e) => {
        if (e.component != "intro") {
          return true;
        } else {
          return false;
        }
      });

      let result = intro.map((e, index) => {
        let x = e.id;
        let y = t.length;

        if (intro[index + 1]) {
          y = intro[index + 1].id;
        }
        let panels = notIntro.filter((e) => {
          if (e.id >= x && e.id <= y) {
            return true;
          } else {
            return false;
          }
        });

        let obj = {
          title: e.title,
          type: e.component,
          position: e.position,
          id: e.id,
          panels: panels,
        };

        return obj;
      });

      this.fTargets = result;
    },
  },
  mounted() {
    this.moveHighlight();
  },
};
</script>

<style lang="scss" scoped>
@use '@/css' as *;

.highlight {
  background: rgba($bg, 0.7);
  height: 0px;
  width: 0px;
  padding: 2em;
  position: absolute;
  top: 2em;
  left: 0px;
  border: solid var(--border) $fg;
  transition: 0.4s;
  pointer-events: none;
  opacity: 0;
  &.on {
    opacity: 1;
  }
}

.menuText {
  position: relative;
  padding: 5em;
  padding-top: 10em;
  width: 100vw;
  box-sizing: border-box;
  left: 0;
  right: 0;
  margin-left: auto;
  margin-right: auto;
  overflow-y: hidden;
  overflow-x: hidden;
  background-color: $fg-spice;
  position: fixed;
  margin-top: calc(var(--border) * -1);
  column-count: 1;
  transition: all 0.8s ease-in-out;
  transition-property: padding, transform, width, height, border;
  border: solid var(--border) $fg;
  &.off {
    transform: translateX(100vw);
  }
  ul {
    list-style: none;
    padding: 1em;
    cursor: pointer;
    transition: 0.4s;
    &:hover {
      padding-left: 2em;
    }
    .current {
      --dot: 30px;
      color: $bg-spice;
      position: relative;
      letter-spacing: 6px;
      &::after {
        content: "";
        position: absolute;
        height: var(--dot);
        width: var(--dot);
        border-radius: 50%;
        background: $bg-spice;
        top: calc(50% - var(--dot) / 2);
        left: calc(var(--dot) * -0.5);
      }
    }
  }
  ul.title {
    margin-bottom: 1em;
  }
  ul.main {
    top: 0vh;
    position: relative;
    z-index: 99;
  }
  li.title,
  .title > p {
    text-indent: 30px;
    margin-top: 30px;
    text-transform: uppercase;
    font-size: 90px;
    font-weight: bold;
    &:nth-of-type(1) {
      margin: 0px;
    }
  }
  .p p {
    --size: 30px;
    text-transform: uppercase;
    text-indent: calc(var(--size) * 3);
    font-size: var(--size);
  }
  li {
    transition: 0.4s;
  }
  li:hover {
    padding-left: 0.5em;
  }
}

.panelMenu {
  position: absolute;
  top: calc(var(--border) * 2);
  width: 100%;
  z-index: 99;
}

.menuBtn {
  cursor: pointer;
  --size: 3em;
  position: fixed;
  z-index: 99;
  margin-top: calc(var(--border) * -1);
  right: 0px;
  width: var(--size);
  height: var(--size);
  background: $bg;
  border-top: solid var(--border) $fg;
  border-bottom: solid var(--border) $fg;
  border-left: solid var(--border) $fg;
  display: flex;
  justify-content: center;
  align-items: center;
  .lines {
    --margin: 10px;
    height: var(--border);
    width: 70%;
    background: $fg;
    &::after,
    &::before {
      content: "";
      height: var(--border);
      width: 70%;
      background: $fg;
      position: absolute;
      left: 0;
      right: 0;
      margin-left: auto;
      margin-right: auto;
    }
    &::before {
      top: var(--margin);
    }
    &::after {
      bottom: var(--margin);
    }
  }
}
</style>
