<template>
  <div>
    <div v-if="location">
      <a>
        <router-link to="/">Back</router-link>
      </a>
      <input v-model="location" type="text" />
      <input v-model="name" type="text" />
      <input v-model="receiving_phone" type="text" />
      <input v-model="sending_phone" type="text" />
      <input v-model="threshold" type="text" />
    </div>
    <button v-on:click="updateProfile">Update Values</button>
  </div>
</template>

<script>
export default {
  name: "Profile",
  data() {
    return {
      test1: "",
      test2: "",
      test3: "",
      test4: "",
      test5: ""
    };
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
    location: {
      get: function() {
        return this.$store.state.profile.location;
      },
      set: function(newLocation) {
        this.$store.dispatch("locationSetter", newLocation);
      }
    },
    name: {
      get: function() {
        return this.$store.state.profile.name;
      },
      set: function(newName) {
        this.$store.dispatch("nameSetter", newName);
      }
    },
    receiving_phone: {
      get: function() {
        return this.$store.state.profile.receiving_phone;
      },
      set: function(newReceiving_phone) {
        this.$store.dispatch("receiving_phoneSetter", newReceiving_phone);
      }
    },
    sending_phone: {
      get: function() {
        return this.$store.state.profile.sending_phone;
      },
      set: function(newSending_phone) {
        this.$store.dispatch("sending_phoneSetter", newSending_phone);
      }
    },
    threshold: {
      get: function() {
        return this.$store.state.profile.threshold;
      },
      set: function(newThreshold) {
        this.$store.dispatch("thresholdSetter", newThreshold);
      }
    }
    // name() {
    //   return this.$store.state.profile.name;
    // },
    // receiving_phone() {
    //   return this.$store.state.profile.receiving_phone;
    // },
    // sending_phone() {
    //   return this.$store.state.profile.sending_phone;
    // },
    // threshold() {
    //   return this.$store.state.profile.threshold;
    // }
  },
  methods: {
    async updateProfile() {
      console.log(this.name);
      var url =
        "/sky/event/GM9rGepSqHudoUUo4DXifS/123/sensor/profile_updated?location=" +
        this.location +
        "&name=" +
        this.name +
        "&receiving=" +
        this.receiving_phone +
        "&sending=" +
        this.sending_phone +
        "&threshold=" +
        this.threshold;
      try {
        this.$store.dispatch("updateProfile", url);
      } catch (error) {
        console.log(error);
      }
    }
  }
};
</script>

<style scoped>
input {
  margin-bottom: 1vw;
}
</style>