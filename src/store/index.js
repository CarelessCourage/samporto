import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    scrollAmount: 0.005,
    scrollMultiplier: 20
  },
  mutations: {
    scrollAmountChange(state, payload) {
      state.scrollAmount = payload;
    },
    scrollMultiplierChange(state, payload) {
      state.scrollMultiplier = payload;
    }
  },
  actions: {
    scrollDeltaChange(context, payload) {
      context.commit("scrollAmountChange", payload);
    }
  },
  modules: {
  }
})
