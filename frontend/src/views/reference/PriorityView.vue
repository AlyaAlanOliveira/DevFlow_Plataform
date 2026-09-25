<template>
  <div>
    <!-- Data Table -->
    <DataTable
      title="Prioridades"
      icon="mdi-flag"
      :headers="headers"
      :items="priorityStore.priorities"
      :loading="priorityStore.loading"
      @add="openDialog()"
      @edit="openDialog($event)"
      @delete="confirmDelete($event)"
    />

    <!-- Dialog Form -->
    <v-dialog v-model="dialog" max-width="600px" persistent>
      <v-card>
        <v-card-title class="bg-primary">
          <span class="text-h6">{{ isEditing ? 'Editar' : 'Nova' }} Prioridade</span>
        </v-card-title>

        <v-card-text class="pt-6">
          <v-form ref="formRef" v-model="formValid">
            <v-row>
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

              <v-col cols="12">
                <v-textarea
                  v-model="form.Description"
                  label="Descrição"
                  rows="3"
                ></v-textarea>
              </v-col>

              <v-col cols="12" md="4">
                <v-text-field
                  v-model.number="form.SLADays"
                  label="SLA (dias) *"
                  type="number"
                  :rules="[rules.required, rules.positive]"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="4">
                <v-text-field
                  v-model="form.ColorHex"
                  label="Cor (Hex)"
                  placeholder="#FF5722"
                  :rules="[rules.hexColor]"
                >
                  <template v-slot:append>
                    <v-menu :close-on-content-click="false">
                      <template v-slot:activator="{ props }">
                        <v-btn
                          icon
                          size="small"
                          v-bind="props"
                          :color="form.ColorHex || 'grey'"
                        >
                          <v-icon>mdi-palette</v-icon>
                        </v-btn>
                      </template>
                      <v-color-picker
                        v-model="form.ColorHex"
                        mode="hex"
                      ></v-color-picker>
                    </v-menu>
                  </template>
                </v-text-field>
              </v-col>

              <v-col cols="12" md="4">
                <v-text-field
                  v-model.number="form.DisplayOrder"
                  label="Ordem *"
                  type="number"
                  :rules="[rules.required, rules.positive]"
                ></v-text-field>
              </v-col>

              <v-col cols="12">
                <v-switch
                  v-model="form.IsActive"
                  label="Ativo"
                  color="success"
                ></v-switch>
              </v-col>
            </v-row>
          </v-form>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            text="Cancelar"
            @click="closeDialog"
          ></v-btn>
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
          Tem certeza que deseja excluir a prioridade <strong>{{ itemToDelete?.Name }}</strong>?
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text="Cancelar" @click="deleteDialog = false"></v-btn>
          <v-btn
            color="error"
            text="Excluir"
            :loading="deleting"
            @click="deleteItem"
          ></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Snackbar -->
    <v-snackbar
      v-model="snackbar"
      :color="snackbarColor"
      :timeout="3000"
    >
      {{ snackbarText }}
    </v-snackbar>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { usePriorityStore } from '@/stores/priorityStore'
import DataTable from '@/components/DataTable.vue'

const priorityStore = usePriorityStore()

// Table headers
const headers = [
  { title: 'Código', key: 'Code', sortable: true },
  { title: 'Nome', key: 'Name', sortable: true },
  { title: 'SLA (dias)', key: 'SLADays', sortable: true },
  { title: 'Cor', key: 'ColorHex', sortable: false },
  { title: 'Ordem', key: 'DisplayOrder', sortable: true },
  { title: 'Status', key: 'IsActive', sortable: true },
  { title: 'Ações', key: 'actions', sortable: false, align: 'center' }
]

// Form
const dialog = ref(false)
const formRef = ref(null)
const formValid = ref(false)
const isEditing = ref(false)
const saving = ref(false)
const form = ref({
  Code: '',
  Name: '',
  Description: '',
  SLADays: 30,
  ColorHex: '#1976D2',
  DisplayOrder: 1,
  IsActive: true
})

// Validation rules
const rules = {
  required: v => !!v || 'Campo obrigatório',
  positive: v => v > 0 || 'Deve ser maior que zero',
  hexColor: v => !v || /^#[0-9A-Fa-f]{6}$/.test(v) || 'Formato inválido (#RRGGBB)'
}

// Delete
const deleteDialog = ref(false)
const itemToDelete = ref(null)
const deleting = ref(false)

// Snackbar
const snackbar = ref(false)
const snackbarText = ref('')
const snackbarColor = ref('success')

// Methods
function openDialog(item = null) {
  if (item) {
    isEditing.value = true
    form.value = { ...item }
  } else {
    isEditing.value = false
    form.value = {
      Code: '',
      Name: '',
      Description: '',
      SLADays: 30,
      ColorHex: '#1976D2',
      DisplayOrder: 1,
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
      await priorityStore.update(form.value.PriorityId, form.value)
      showSnackbar('Prioridade atualizada com sucesso!', 'success')
    } else {
      await priorityStore.create(form.value)
      showSnackbar('Prioridade criada com sucesso!', 'success')
    }
    closeDialog()
  } catch (error) {
    showSnackbar('Erro ao salvar prioridade: ' + error.message, 'error')
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
    await priorityStore.remove(itemToDelete.value.PriorityId)
    showSnackbar('Prioridade excluída com sucesso!', 'success')
    deleteDialog.value = false
  } catch (error) {
    showSnackbar('Erro ao excluir prioridade: ' + error.message, 'error')
  } finally {
    deleting.value = false
  }
}

function showSnackbar(text, color = 'success') {
  snackbarText.value = text
  snackbarColor.value = color
  snackbar.value = true
}

// Load data on mount
onMounted(() => {
  priorityStore.fetchAll()
})
</script>
