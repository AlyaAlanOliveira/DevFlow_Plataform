<template>
  <div>
    <!-- Data Table -->
    <DataTable
      title="Configuração Entra ID (Azure AD)"
      icon="mdi-microsoft-azure"
      :headers="headers"
      :items="store.tenants"
      :loading="store.loading"
      @add="openDialog()"
      @edit="openDialog($event)"
      @delete="confirmDelete($event)"
    >
      <template #actions="{ item }">
        <v-btn
          icon="mdi-test-tube"
          size="small"
          variant="text"
          color="info"
          @click="testConfiguration(item)"
          title="Testar Configuração"
        ></v-btn>
      </template>
    </DataTable>

    <!-- Dialog Form -->
    <v-dialog v-model="dialog" max-width="900px" persistent scrollable>
      <v-card>
        <v-card-title class="bg-primary">
          <span class="text-h6">
            <v-icon start>mdi-microsoft-azure</v-icon>
            {{ isEditing ? 'Editar' : 'Nova' }} Configuração Entra ID
          </span>
        </v-card-title>

        <v-card-text class="pt-6">
          <v-form ref="formRef" v-model="formValid">
            <!-- Informações da Empresa -->
            <v-row>
              <v-col cols="12">
                <h4 class="text-primary mb-2">
                  <v-icon start>mdi-domain</v-icon>
                  Empresa
                </h4>
                <v-divider class="mb-4"></v-divider>
              </v-col>

              <v-col cols="12">
                <v-select
                  v-model="form.CompanyId"
                  label="Empresa *"
                  :items="companies"
                  item-title="Nome"
                  item-value="CompanyId"
                  :rules="[rules.required]"
                  :disabled="isEditing"
                ></v-select>
              </v-col>
            </v-row>

            <!-- Configuração Entra ID -->
            <v-row>
              <v-col cols="12">
                <h4 class="text-primary mb-2 mt-4">
                  <v-icon start>mdi-cloud</v-icon>
                  Tenant Entra ID
                </h4>
                <v-divider class="mb-4"></v-divider>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.TenantId"
                  label="Tenant ID *"
                  :rules="[rules.required, rules.uuid]"
                  hint="UUID do Tenant no Azure AD"
                  persistent-hint
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.TenantName"
                  label="Tenant Name *"
                  :rules="[rules.required]"
                  hint="Ex: alya.onmicrosoft.com"
                  persistent-hint
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.TenantDomain"
                  label="Domínio *"
                  :rules="[rules.required, rules.domain]"
                  hint="Ex: alya.com.br"
                  persistent-hint
                ></v-text-field>
              </v-col>
            </v-row>

            <!-- App Registration -->
            <v-row>
              <v-col cols="12">
                <h4 class="text-primary mb-2 mt-4">
                  <v-icon start>mdi-application</v-icon>
                  App Registration
                </h4>
                <v-divider class="mb-4"></v-divider>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.ClientId"
                  label="Client ID *"
                  :rules="[rules.required, rules.uuid]"
                  hint="Application (client) ID do Azure"
                  persistent-hint
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.ClientSecret"
                  label="Client Secret"
                  type="password"
                  hint="Deixe vazio para manter o atual"
                  persistent-hint
                  :append-icon="showSecret ? 'mdi-eye' : 'mdi-eye-off'"
                  @click:append="showSecret = !showSecret"
                  :type="showSecret ? 'text' : 'password'"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.CertificateThumbprint"
                  label="Certificate Thumbprint"
                  hint="Alternativa ao Client Secret"
                  persistent-hint
                ></v-text-field>
              </v-col>
            </v-row>

            <!-- Endpoints -->
            <v-row>
              <v-col cols="12">
                <h4 class="text-primary mb-2 mt-4">
                  <v-icon start>mdi-link</v-icon>
                  Endpoints
                </h4>
                <v-divider class="mb-4"></v-divider>
              </v-col>

              <v-col cols="12">
                <v-text-field
                  v-model="form.Authority"
                  label="Authority URL *"
                  :rules="[rules.required, rules.url]"
                  hint="Ex: https://login.microsoftonline.com/{tenant-id}"
                  persistent-hint
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.RedirectUri"
                  label="Redirect URI *"
                  :rules="[rules.required, rules.url]"
                  hint="Ex: http://localhost:5173/auth/callback"
                  persistent-hint
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.PostLogoutRedirectUri"
                  label="Post Logout Redirect URI"
                  :rules="[rules.url]"
                  hint="URL após logout"
                  persistent-hint
                ></v-text-field>
              </v-col>
            </v-row>

            <!-- Configurações -->
            <v-row>
              <v-col cols="12">
                <h4 class="text-primary mb-2 mt-4">
                  <v-icon start>mdi-cog</v-icon>
                  Configurações
                </h4>
                <v-divider class="mb-4"></v-divider>
              </v-col>

              <v-col cols="12" md="4">
                <v-switch
                  v-model="form.IsActive"
                  label="Ativo"
                  color="success"
                ></v-switch>
              </v-col>

              <v-col cols="12" md="4">
                <v-switch
                  v-model="form.AllowAutoUserCreation"
                  label="Criar Usuários Automaticamente"
                  color="primary"
                  hint="Criar usuário no primeiro login"
                ></v-switch>
              </v-col>

              <v-col cols="12" md="4">
                <v-switch
                  v-model="form.RequireGroupMembership"
                  label="Requer Grupo Específico"
                  color="warning"
                  hint="Validar grupo do Azure AD"
                ></v-switch>
              </v-col>

              <v-col cols="12">
                <v-textarea
                  v-model="form.Description"
                  label="Descrição"
                  rows="2"
                ></v-textarea>
              </v-col>

              <v-col cols="12">
                <v-textarea
                  v-model="form.ConfigurationNotes"
                  label="Notas de Configuração"
                  rows="3"
                  hint="Informações técnicas, contatos, etc."
                  persistent-hint
                ></v-textarea>
              </v-col>
            </v-row>
          </v-form>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text="Cancelar" @click="closeDialog"></v-btn>
          <v-btn
            color="primary"
            text="Salvar"
            :loading="saving"
            :disabled="!formValid"
            @click="save"
          ></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="deleteDialog" max-width="500px">
      <v-card>
        <v-card-title class="text-h6">
          <v-icon start color="error">mdi-alert</v-icon>
          Confirmar Exclusão
        </v-card-title>
        <v-card-text>
          <p class="mb-2">Tem certeza que deseja excluir a configuração do tenant:</p>
          <p class="text-h6 text-primary">{{ itemToDelete?.TenantName }}</p>
          <v-alert type="warning" class="mt-4">
            <strong>Atenção:</strong> Usuários não poderão mais fazer login via este tenant!
          </v-alert>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text="Cancelar" @click="deleteDialog = false"></v-btn>
          <v-btn color="error" text="Excluir" :loading="deleting" @click="deleteItem"></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Test Result Dialog -->
    <v-dialog v-model="testDialog" max-width="600px">
      <v-card>
        <v-card-title class="text-h6">
          <v-icon start :color="testResult?.Success ? 'success' : 'error'">
            {{ testResult?.Success ? 'mdi-check-circle' : 'mdi-alert-circle' }}
          </v-icon>
          Resultado do Teste
        </v-card-title>
        <v-card-text>
          <v-alert :type="testResult?.Success ? 'success' : 'error'" class="mb-4">
            {{ testResult?.Message }}
          </v-alert>
          
          <div v-if="testResult?.Details">
            <h4 class="mb-2">Detalhes:</h4>
            <pre class="pa-2 bg-grey-lighten-4 rounded">{{ JSON.stringify(testResult.Details, null, 2) }}</pre>
          </div>

          <div v-if="testResult?.issues && testResult.issues.length > 0">
            <h4 class="mb-2">Problemas Encontrados:</h4>
            <v-list density="compact">
              <v-list-item v-for="(issue, index) in testResult.issues" :key="index">
                <template #prepend>
                  <v-icon color="error">mdi-alert</v-icon>
                </template>
                {{ issue }}
              </v-list-item>
            </v-list>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text="Fechar" @click="testDialog = false"></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Snackbar -->
    <v-snackbar v-model="snackbar" :color="snackbarColor" :timeout="3000">
      {{ snackbarText }}
    </v-snackbar>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useEntraidTenantStore } from '@/stores/entraidTenantStore'
import DataTable from '@/components/DataTable.vue'

const store = useEntraidTenantStore()

// Mock companies - TODO: Replace with actual company store
const companies = ref([
  { CompanyId: '00000000-0000-0000-0000-000000000001', Nome: 'ALYA Serviços' },
  { CompanyId: '00000000-0000-0000-0000-000000000002', Nome: 'Mobyan' },
  { CompanyId: '00000000-0000-0000-0000-000000000003', Nome: 'TaNaPorta' }
])

const headers = [
  { title: 'Empresa', key: 'CompanyId', sortable: true },
  { title: 'Tenant Name', key: 'TenantName', sortable: true },
  { title: 'Domínio', key: 'TenantDomain', sortable: true },
  { title: 'Usuários Sync', key: 'TotalUsersSync', sortable: true },
  { title: 'Último Login', key: 'LastLoginDate', sortable: true },
  { title: 'Status', key: 'IsActive', sortable: true },
  { title: 'Ações', key: 'actions', sortable: false, align: 'center' }
]

const dialog = ref(false)
const formRef = ref(null)
const formValid = ref(false)
const isEditing = ref(false)
const saving = ref(false)
const showSecret = ref(false)

const form = ref({
  CompanyId: '',
  TenantId: '',
  TenantName: '',
  TenantDomain: '',
  ClientId: '',
  ClientSecret: '',
  CertificateThumbprint: '',
  Authority: '',
  RedirectUri: 'http://localhost:5173/auth/callback',
  PostLogoutRedirectUri: '',
  IsActive: true,
  AllowAutoUserCreation: true,
  RequireGroupMembership: false,
  Description: '',
  ConfigurationNotes: ''
})

const rules = {
  required: v => !!v || 'Campo obrigatório',
  uuid: v => !v || /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(v) || 'UUID inválido',
  domain: v => !v || /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,}$/i.test(v) || 'Domínio inválido',
  url: v => !v || /^https?:\/\/.+/.test(v) || 'URL inválida'
}

const deleteDialog = ref(false)
const itemToDelete = ref(null)
const deleting = ref(false)

const testDialog = ref(false)
const testResult = ref(null)

const snackbar = ref(false)
const snackbarText = ref('')
const snackbarColor = ref('success')

function openDialog(item = null) {
  if (item) {
    isEditing.value = true
    form.value = { ...item, ClientSecret: '' } // Don't show existing secret
  } else {
    isEditing.value = false
    form.value = {
      CompanyId: '',
      TenantId: '',
      TenantName: '',
      TenantDomain: '',
      ClientId: '',
      ClientSecret: '',
      CertificateThumbprint: '',
      Authority: '',
      RedirectUri: 'http://localhost:5173/auth/callback',
      PostLogoutRedirectUri: '',
      IsActive: true,
      AllowAutoUserCreation: true,
      RequireGroupMembership: false,
      Description: '',
      ConfigurationNotes: ''
    }
  }
  dialog.value = true
}

function closeDialog() {
  dialog.value = false
  formRef.value?.reset()
  showSecret.value = false
}

async function save() {
  if (!formValid.value) return

  saving.value = true
  try {
    // Remove ClientSecret if empty (don't update)
    const dataToSave = { ...form.value }
    if (!dataToSave.ClientSecret) {
      delete dataToSave.ClientSecret
    }

    if (isEditing.value) {
      await store.update(form.value.EntraIDTenantId, dataToSave)
      showSnackbar('Configuração atualizada com sucesso!', 'success')
    } else {
      await store.create(dataToSave)
      showSnackbar('Configuração criada com sucesso!', 'success')
    }
    closeDialog()
  } catch (error) {
    showSnackbar('Erro ao salvar: ' + error.message, 'error')
  } finally {
    saving.value = false
  }
}

function confirmDelete(item) {
  itemToDelete.value = item
  deleteDialog.value = true
}

async function deleteItem() {
  deleting.value = true
  try {
    await store.remove(itemToDelete.value.EntraIDTenantId)
    showSnackbar('Configuração excluída com sucesso!', 'success')
    deleteDialog.value = false
  } catch (error) {
    showSnackbar('Erro ao excluir: ' + error.message, 'error')
  } finally {
    deleting.value = false
  }
}

async function testConfiguration(item) {
  try {
    testResult.value = await store.testConfig(item.EntraIDTenantId)
    testDialog.value = true
  } catch (error) {
    showSnackbar('Erro ao testar configuração: ' + error.message, 'error')
  }
}

function showSnackbar(text, color = 'success') {
  snackbarText.value = text
  snackbarColor.value = color
  snackbar.value = true
}

onMounted(() => {
  store.fetchAll()
})
</script>
