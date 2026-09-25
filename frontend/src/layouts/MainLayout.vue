<template>
  <v-app>
    <!-- App Bar -->
    <v-app-bar color="primary" prominent>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      
      <v-toolbar-title class="text-h5 font-weight-bold">
        DevFlow ALYA
      </v-toolbar-title>

      <v-spacer></v-spacer>

      <!-- User Menu -->
      <v-menu>
        <template v-slot:activator="{ props }">
          <v-btn icon v-bind="props">
            <v-icon>mdi-account-circle</v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item>
            <v-list-item-title>Usuário Admin</v-list-item-title>
            <v-list-item-subtitle>admin@alya.com.br</v-list-item-subtitle>
          </v-list-item>
          <v-divider></v-divider>
          <v-list-item @click="logout">
            <v-list-item-title>
              <v-icon start>mdi-logout</v-icon>
              Sair
            </v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>

    <!-- Navigation Drawer -->
    <v-navigation-drawer v-model="drawer" temporary>
      <v-list>
        <v-list-item
          prepend-icon="mdi-view-dashboard"
          title="Dashboard"
          to="/"
        ></v-list-item>
      </v-list>

      <v-divider></v-divider>

      <!-- Referência -->
      <v-list>
        <v-list-subheader>REFERÊNCIA</v-list-subheader>
        
        <v-list-item
          prepend-icon="mdi-flag"
          title="Prioridades"
          to="/priorities"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-file-document"
          title="Tipos de Demanda"
          to="/demand-types"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-state-machine"
          title="Status de Workflow"
          to="/workflow-status"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-account-group"
          title="Complexidade de Atores"
          to="/actor-complexities"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-sitemap"
          title="Complexidade de Casos de Uso"
          to="/usecase-complexities"
        ></v-list-item>
      </v-list>

      <v-divider></v-divider>

      <!-- Configuração -->
      <v-list>
        <v-list-subheader>CONFIGURAÇÃO</v-list-subheader>
        
        <v-list-item
          prepend-icon="mdi-office-building"
          title="Operações"
          to="/operations"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-calculator"
          title="Configurações UCP"
          to="/ucp-configurations"
        ></v-list-item>
      </v-list>
    </v-navigation-drawer>

    <!-- Main Content -->
    <v-main>
      <v-container fluid>
        <router-view />
      </v-container>
    </v-main>

    <!-- Footer -->
    <v-footer app>
      <v-spacer></v-spacer>
      <span class="text-caption">
        © 2026 DevFlow ALYA - Grupo ALYA | Mobyan | TaNaPorta
      </span>
      <v-spacer></v-spacer>
    </v-footer>
  </v-app>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const drawer = ref(false)
const router = useRouter()

const logout = () => {
  // TODO: Implementar logout
  console.log('Logout')
  router.push('/')
}
</script>

<style scoped>
.v-toolbar-title {
  letter-spacing: 0.5px;
}
</style>
