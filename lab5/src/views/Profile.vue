<template>
  <div v-if="location !== null">
    <p>yo</p>
    <input v-model="receiving_phone" type="text" />
  </div>
</template>

<script>
export default {
  name: "Profile",
  data() {
    return {};
  },
  created() {
    this.$store.dispatch("getProfile");
  },
  // ent:sensor_location := event:attr("location")
  //   ent:sensor_name := event:attr("name")
  //   ent:receiving_phone := event:attr("receiving").as("Number")
  //   ent:sending_phone := event:attr("sending").as("Number")
  //   ent:temperature_threshold := event:attr("threshold").as("Number")
  //   getProfile = function() {
  //   return {"location": sensor_location, "name": sensor_name, "threshold": temperature_threshold, "receiving_phone": receiving_phone, "sending_phone": sending_phone }
  // }
  computed: {
    location() {
      return this.$store.state.profile.location;
    },
    name() {
      return this.$store.state.profile.name;
    },
    receiving_phone() {
      return this.$store.state.profile.receiving_phone;
    },
    sending_phone() {
      return this.$store.state.profile.sending_phone;
    },
    threshold() {
      return this.$store.state.profile.threshold;
    }
  }
};
</script>