import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    scrollAmount: 0.005
  },
  mutations: {
    scrollAmountChange(state, payload) {
      state.scrollAmount += payload;
    }
  },
  actions: {
  },
  modules: {
  }
})
