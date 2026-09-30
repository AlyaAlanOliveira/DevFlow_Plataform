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

      <!-- Governança -->
      <v-list>
        <v-list-subheader>GOVERNANÇA</v-list-subheader>
        
        <v-list-item
          prepend-icon="mdi-domain"
          title="Holdings"
          to="/governance/holdings"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-office-building"
          title="Empresas"
          to="/governance/companies"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-office-building-outline"
          title="Diretorias"
          to="/governance/directorates"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-view-grid"
          title="Áreas"
          to="/governance/areas"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-account-group"
          title="Squads"
          to="/governance/squads"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-account-multiple"
          title="Membros de Squad"
          to="/governance/squad-members"
        ></v-list-item>
      </v-list>

      <v-divider></v-divider>

      <!-- Segurança -->
      <v-list>
        <v-list-subheader>SEGURANÇA</v-list-subheader>
        
        <v-list-item
          prepend-icon="mdi-account"
          title="Usuários"
          to="/security/users"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-shield-account"
          title="Perfis (Roles)"
          to="/security/roles"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-key"
          title="Permissões"
          to="/security/permissions"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-account-key"
          title="Perfis de Usuário"
          to="/security/user-roles"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-shield-lock"
          title="Autorizações de Prioridade"
          to="/security/priority-authorizations"
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
          prepend-icon="mdi-cog"
          title="Operações / Clientes"
          to="/operations"
        ></v-list-item>

        <v-list-item
          prepend-icon="mdi-calculator"
          title="Configurações UCP"
          to="/ucp-configurations"
        ></v-list-item>
      </v-list>

      <v-divider></v-divider>

      <!-- Administração (Apenas Admin DevFlow) -->
      <v-list v-if="isAdminDevFlow">
        <v-list-subheader>
          <v-icon start size="small" color="error">mdi-shield-crown</v-icon>
          ADMINISTRAÇÃO
        </v-list-subheader>
        
        <v-list-item
          prepend-icon="mdi-microsoft-azure"
          title="Configuração Entra ID"
          to="/admin/entraid-tenants"
        >
          <template #append>
            <v-chip size="x-small" color="error" variant="flat">ADMIN</v-chip>
          </template>
        </v-list-item>
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

// TODO: Obter do usuário autenticado
// Por enquanto, mock para desenvolvimento
const isAdminDevFlow = ref(true) // Mudar para false para testar sem admin

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
