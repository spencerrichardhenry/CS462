<template>
  <div class="home">
    <div class="col-lg">
      <a>
        <router-link to="/profile">View/change profile</router-link>
      </a>
      <br />Current temperature:
      <span
        v-if="temps[temps.length - 1].temp > tempThreshold"
        class="overThreshold"
      >
        <b>{{temps[temps.length - 1].temp}}</b>
      </span>
      <span v-else>
        <b>{{temps[temps.length - 1].temp}}</b>
      </span>
      <br />

      <span class="overThreshold">Red text</span> indicates that a temperature reading is over the threshold.
      <br />
      <br />
      <br />
      <div v-if="temps !== undefined">
        <div v-for="(temp, id) in temps" :key="id">
          <div v-if="temp !== null">
            <div v-if="temp.temp > tempThreshold" class="overThreshold">
              <b>{{temp.temp}}</b>
            </div>
            <div v-else>
              <b>{{temp.temp}}</b>
            </div>
            {{temp.timestamp}}
            <br />
            <hr />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Home",
  data() {
    return {};
  },
  created() {
    this.$store.dispatch("getTemps");
  },
  computed: {
    temps() {
      return this.$store.state.temps;
    },
    violations() {
      return this.$store.state.violations;
    },
    tempThreshold() {
      return this.$store.state.tempThreshold;
    }
  }
};
</script>

<style scoped>
.overThreshold {
  color: red !important;
}
</style>