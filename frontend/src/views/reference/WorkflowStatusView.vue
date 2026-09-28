<template>
  <div>
    <!-- Data Table -->
    <DataTable
      title="Status de Workflow"
      icon="mdi-state-machine"
      :headers="headers"
      :items="store.workflowStatuses"
      :loading="store.loading"
      @add="openDialog()"
      @edit="openDialog($event)"
      @delete="confirmDelete($event)"
    />

    <!-- Dialog Form -->
    <v-dialog v-model="dialog" max-width="700px" persistent>
      <v-card>
        <v-card-title class="bg-primary">
          <span class="text-h6">{{ isEditing ? 'Editar' : 'Novo' }} Status de Workflow</span>
        </v-card-title>

        <v-card-text class="pt-6">
          <v-form ref="formRef" v-model="formValid">
            <v-row>
              <v-col cols="12" md="6">
                <v-select
                  v-model="form.EntityType"
                  label="Tipo de Entidade *"
                  :items="entityTypes"
                  :rules="[rules.required]"
                ></v-select>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.Code"
                  label="Código *"
                  :rules="[rules.required]"
                  :disabled="isEditing"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.Name"
                  label="Nome *"
                  :rules="[rules.required]"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="form.ColorHex"
                  label="Cor (Hex)"
                  type="color"
                ></v-text-field>
              </v-col>

              <v-col cols="12">
                <v-textarea
                  v-model="form.Description"
                  label="Descrição"
                  rows="2"
                ></v-textarea>
              </v-col>

              <v-col cols="12" md="4">
                <v-text-field
                  v-model.number="form.DisplayOrder"
                  label="Ordem de Exibição *"
                  type="number"
                  :rules="[rules.required]"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="8">
                <v-row>
                  <v-col cols="4">
                    <v-switch
                      v-model="form.IsFinal"
                      label="Status Final"
                      color="primary"
                    ></v-switch>
                  </v-col>
                  <v-col cols="4">
                    <v-switch
                      v-model="form.IsRejection"
                      label="Rejeição"
                      color="error"
                    ></v-switch>
                  </v-col>
                  <v-col cols="4">
                    <v-switch
                      v-model="form.IsActive"
                      label="Ativo"
                      color="success"
                    ></v-switch>
                  </v-col>
                </v-row>
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
    <v-dialog v-model="deleteDialog" max-width="400px">
      <v-card>
        <v-card-title class="text-h6">Confirmar Exclusão</v-card-title>
        <v-card-text>
          Tem certeza que deseja excluir o status <strong>{{ itemToDelete?.Name }}</strong>?
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text="Cancelar" @click="deleteDialog = false"></v-btn>
          <v-btn color="error" text="Excluir" :loading="deleting" @click="deleteItem"></v-btn>
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
import { useWorkflowStatusStore } from '@/stores/workflowStatusStore'
import DataTable from '@/components/DataTable.vue'

const store = useWorkflowStatusStore()

const entityTypes = [
  'BusinessCase',
  'Demand',
  'Requirement',
  'UseCase',
  'UserStory',
  'Sprint',
  'Release',
  'GMUD'
]

const headers = [
  { title: 'Entidade', key: 'EntityType', sortable: true },
  { title: 'Código', key: 'Code', sortable: true },
  { title: 'Nome', key: 'Name', sortable: true },
  { title: 'Ordem', key: 'DisplayOrder', sortable: true },
  { title: 'Final', key: 'IsFinal', sortable: true },
  { title: 'Status', key: 'IsActive', sortable: true },
  { title: 'Ações', key: 'actions', sortable: false, align: 'center' }
]

const dialog = ref(false)
const formRef = ref(null)
const formValid = ref(false)
const isEditing = ref(false)
const saving = ref(false)
const form = ref({
  EntityType: '',
  Code: '',
  Name: '',
  Description: '',
  ColorHex: '#2196F3',
  DisplayOrder: 1,
  IsFinal: false,
  IsRejection: false,
  IsActive: true
})

const rules = {
  required: v => !!v || 'Campo obrigatório'
}

const deleteDialog = ref(false)
const itemToDelete = ref(null)
const deleting = ref(false)

const snackbar = ref(false)
const snackbarText = ref('')
const snackbarColor = ref('success')

function openDialog(item = null) {
  if (item) {
    isEditing.value = true
    form.value = { ...item }
  } else {
    isEditing.value = false
    form.value = {
      EntityType: '',
      Code: '',
      Name: '',
      Description: '',
      ColorHex: '#2196F3',
      DisplayOrder: 1,
      IsFinal: false,
      IsRejection: false,
      IsActive: true
    }
  }
  dialog.value = true
}

function closeDialog() {
  dialog.value = false
  formRef.value?.reset()
}

async function save() {
  if (!formValid.value) return

  saving.value = true
  try {
    if (isEditing.value) {
      await store.update(form.value.WorkflowStatusId, form.value)
      showSnackbar('Status atualizado com sucesso!', 'success')
    } else {
      await store.create(form.value)
      showSnackbar('Status criado com sucesso!', 'success')
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
    await store.remove(itemToDelete.value.WorkflowStatusId)
    showSnackbar('Status excluído com sucesso!', 'success')
    deleteDialog.value = false
  } catch (error) {
    showSnackbar('Erro ao excluir: ' + error.message, 'error')
  } finally {
    deleting.value = false
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
