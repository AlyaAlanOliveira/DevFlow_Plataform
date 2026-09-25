<template>
  <v-card>
    <v-card-title class="d-flex align-center">
      <v-icon start>{{ icon }}</v-icon>
      {{ title }}
      
      <v-spacer></v-spacer>

      <!-- Search -->
      <v-text-field
        v-model="search"
        prepend-inner-icon="mdi-magnify"
        label="Pesquisar"
        single-line
        hide-details
        density="compact"
        style="max-width: 300px"
        class="mr-4"
      ></v-text-field>

      <!-- Add Button -->
      <v-btn
        color="primary"
        prepend-icon="mdi-plus"
        @click="$emit('add')"
      >
        Adicionar
      </v-btn>
    </v-card-title>

    <v-divider></v-divider>

    <!-- Data Table -->
    <v-data-table
      :headers="headers"
      :items="items"
      :search="search"
      :loading="loading"
      :items-per-page="itemsPerPage"
      class="elevation-0"
    >
      <!-- Active Status Chip -->
      <template v-slot:item.IsActive="{ item }">
        <v-chip
          :color="item.IsActive ? 'success' : 'error'"
          size="small"
          variant="flat"
        >
          {{ item.IsActive ? 'Ativo' : 'Inativo' }}
        </v-chip>
      </template>

      <!-- Color Preview -->
      <template v-slot:item.ColorHex="{ item }">
        <v-chip
          v-if="item.ColorHex"
          :color="item.ColorHex"
          size="small"
        >
          {{ item.ColorHex }}
        </v-chip>
      </template>

      <!-- Actions -->
      <template v-slot:item.actions="{ item }">
        <v-btn
          icon="mdi-pencil"
          size="small"
          variant="text"
          @click="$emit('edit', item)"
        ></v-btn>
        <v-btn
          icon="mdi-delete"
          size="small"
          variant="text"
          color="error"
          @click="$emit('delete', item)"
        ></v-btn>
      </template>

      <!-- Loading -->
      <template v-slot:loading>
        <v-skeleton-loader type="table-row@10"></v-skeleton-loader>
      </template>

      <!-- No Data -->
      <template v-slot:no-data>
        <v-alert
          type="info"
          variant="tonal"
          class="ma-4"
        >
          Nenhum registro encontrado
        </v-alert>
      </template>
    </v-data-table>
  </v-card>
</template>

<script setup>
import { ref } from 'vue'

defineProps({
  title: {
    type: String,
    required: true
  },
  icon: {
    type: String,
    default: 'mdi-table'
  },
  headers: {
    type: Array,
    required: true
  },
  items: {
    type: Array,
    default: () => []
  },
  loading: {
    type: Boolean,
    default: false
  },
  itemsPerPage: {
    type: Number,
    default: 10
  }
})

defineEmits(['add', 'edit', 'delete'])

const search = ref('')
</script>
