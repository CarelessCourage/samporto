<template>
  <div id="expanded" :class="{ expanded: expanded }">
    <div class="header" v-if="false"></div>
  </div>
</template>


<script>
export default {
  name: "expanded",
  props: {
    expanded: Boolean,
  },
  methods: {},
};
</script>

<style lang="scss">
#expanded {
  background: white;
  transition: 0.4s;
  overflow: hidden;
}

.expanded {
  height: 100vh;
}

.header {
  border: 1px solid red;
  height: 35vh;
}
</style>
