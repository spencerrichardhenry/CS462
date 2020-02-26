import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";


Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    temps: null,
    violations: null,
    tempThreshold: 73.0,
    profile: { location: "", name: "", receiving_phone: "", sending_phone: "", threshold: "" }
  },
  mutations: {
    setTemps(state, temps) {
      state.temps = temps;
    },
    setViolations(state, violations) {
      state.violations = violations;
    },
    setTempThreshold(state, tempThreshold) {
      state.tempThreshold = tempThreshold;
    },
    setProfile(state, profile) {
      state.profile = profile;
      state.tempThreshold = profile.threshold;
    },
    setLocation(state, location) {
      state.profile.location = location;
    },
    setName(state, name) {
      state.profile.name = name;
    },
    setReceiving_phone(state, receiving_phone) {
      state.profile.receiving_phone = receiving_phone;
    },
    setSending_phone(state, sending_phone) {
      state.profile.sending_phone = sending_phone;
    },
    setThreshold(state, threshold) {
      state.profile.threshold = threshold;
    },
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
        await this.dispatch("getProfile", context);
        return "";
      } catch (error) {
        return "";
      }
    },
    async getProfile(context) {
      try {
        let response = await axios.get("/sky/cloud/GM9rGepSqHudoUUo4DXifS/sensor_profile/getProfile");
        context.commit("setProfile", response.data);
      } catch (error) {
        console.log(error);
        return "";
      }
    },
    async updateProfile(context, url) {
      try {
        console.log(url)
        let response = await axios.post(url);
        // let response = await axios.post("/sky/event/GM9rGepSqHudoUUo4DXifS/123/sensor/profile_updated?location=" + location + "&name=" + name + "&receiving=" + receiving + "&sending=" + sending + "&threshold=" + threshold);
        console.log("response from updateProfile api: " + response);
        console.log("context: " + context);
      } catch (error) {
        console.log(error);
        return "";
      }
    },
    locationSetter(context, location) {
      context.commit("setLocation", location);
    },
    nameSetter(context, name) {
      context.commit("setName", name);
    },
    receiving_phoneSetter(context, receiving_phone) {
      context.commit("setReceiving_phone", receiving_phone);
    },
    sending_phoneSetter(context, sending_phone) {
      context.commit("setSending_phone", sending_phone);
    },
    thresholdSetter(context, threshold) {
      context.commit("setThreshold", threshold);
    },
  },
  modules: {}
});
