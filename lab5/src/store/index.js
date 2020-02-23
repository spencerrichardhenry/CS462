import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";


Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    temps: null,
    violations: null,
    tempThreshold: 73.0
  },
  mutations: {
    setTemps(state, temps) {
      if (temps[37] > state.tempThreshold) console.log("temps37 > threshold");
      console.log(temps[37].temp);
      console.log(state.tempThreshold)
      console.log(temps[37].temp > state.tempThreshold);

      state.temps = temps;
    },
    setViolations(state, violations) {
      state.violations = violations;
    },
    setTempThreshold(state, tempThreshold) {
      state.tempThreshold = tempThreshold;
    }
  },
  actions: {
    async getViolations(context) {
      try {
        let response = await axios.get("/sky/cloud/GM9rGepSqHudoUUo4DXifS/temperature_store/threshold_violations");
        context.commit("setViolations", response.data);
      } catch (error) {
        console.log(error);
        return "";
      }
    },
    async getTemps(context) {
      try {
        let response = await axios.get("/sky/cloud/GM9rGepSqHudoUUo4DXifS/temperature_store/temperatures");
        context.commit("setTemps", response.data);
        await this.dispatch("getViolations", context);
        return "";
      } catch (error) {
        return "";
      }
    }
  },
  modules: {}
});
