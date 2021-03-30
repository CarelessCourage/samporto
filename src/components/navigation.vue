<template>
  <div id="nav">
    <h1 class="logo">Facts > Feeling</h1>
    <transition name="burger">
      <div
        class="bg"
        :class="{ cross: navigation }"
        @click="clickedNav"
        v-if="!expanded"
      >
        <div class="burger">
          <div class="lines"></div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: "Navigation",
  props: ["navigation", "expanded"],
  data() {
    return {};
  },

  methods: {
    clickedNav: function () {
      this.$emit("navClick");
    },
  },
};
</script>

<style lang="scss">
@use '@/css' as *;

#nav {
  position: relative;
  width: 100vw;
  height: 100vh;
}

.burger {
  --size: 2em;
  --lineH: 0.25em;

  position: relative;
  width: calc(var(--size) + 0.5em);
  height: var(--size);
  display: flex;
  align-items: center;
  transition: transform 0.4s ease-in-out;
  .lines {
    width: 100%;
    height: var(--lineH);
    background: $fg;
    transition: background 0.4s ease-in-out, top 0.4s ease-in-out 0.4s,
      bottom 0.4s ease-in-out 0.4s, transform 0.4s;
    &::before {
      @extend .lines;
      content: "";
      position: absolute;
      top: 0em;
      left: 0em;
    }
    &::after {
      @extend .lines;
      content: "";
      position: absolute;
      bottom: 0em;
      left: 0em;
    }
  }
}

.bg {
  position: absolute;
  right: 2em;
  top: 2em;
  z-index: 100;
  transition: transform 0.4s ease-in-out, background 0.4s ease-in-out;
  background: $bg;
  cursor: pointer;
  transition: 0.4s;
  &:hover {
    border: 2px solid $fg;
  }
  transform: scale(1.5);
  .burger {
    transform: scale(0.5);
  }
}

.bg.cross {
  background: none;
  border: none;
  transform: scale(1);
  .burger {
    transform: rotate(45deg);
  }

  .lines {
    background: $bg;
    &::before {
      top: calc(50% - 0.19em);
      transform: rotate(90deg);
    }
    &::after {
      opacity: 1;
      bottom: calc(50% - 0.19em);
    }
  }
}

.logo {
  width: 5em;
  margin-top: 0.3em;
  font-size: 3em;
  line-height: 1em;
  color: $bg;
}

.burger-enter-active,
.burger-leave-active {
  transition: opacity 0.5s;
}
.burger-enter, .burger-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>
