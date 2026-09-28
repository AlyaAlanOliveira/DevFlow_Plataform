<template>
  <div>
    <!-- Data Table -->
    <DataTable
      title="Complexidade de Casos de Uso UCP"
      icon="mdi-file-tree"
      :headers="headers"
      :items="store.useCaseComplexities"
      :loading="store.loading"
      @add="openDialog()"
      @edit="openDialog($event)"
      @delete="confirmDelete($event)"
    />

    <!-- Dialog Form -->
    <v-dialog v-model="dialog" max-width="600px" persistent>
      <v-card>
        <v-card-title class="bg-primary">
          <span class="text-h6">{{ isEditing ? 'Editar' : 'Nova' }} Complexidade de Caso de Uso</span>
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
                  v-model.number="form.Weight"
                  label="Peso (UUCW) *"
                  type="number"
                  :rules="[rules.required, rules.positive]"
                  hint="Peso para cálculo UCP"
                  persistent-hint
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="4">
                <v-text-field
                  v-model.number="form.MinTransactions"
                  label="Mín. Transações *"
                  type="number"
                  :rules="[rules.required, rules.positive]"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="4">
                <v-text-field
                  v-model.number="form.MaxTransactions"
                  label="Máx. Transações"
                  type="number"
                  hint="Deixe vazio para ilimitado"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model.number="form.DisplayOrder"
                  label="Ordem de Exibição *"
                  type="number"
                  :rules="[rules.required]"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
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
          Tem certeza que deseja excluir a complexidade <strong>{{ itemToDelete?.Name }}</strong>?
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
import { useUseCaseComplexityStore } from '@/stores/useCaseComplexityStore'
import DataTable from '@/components/DataTable.vue'

const store = useUseCaseComplexityStore()

const headers = [
  { title: 'Código', key: 'Code', sortable: true },
  { title: 'Nome', key: 'Name', sortable: true },
  { title: 'Peso (UUCW)', key: 'Weight', sortable: true },
  { title: 'Mín. Trans.', key: 'MinTransactions', sortable: true },
  { title: 'Máx. Trans.', key: 'MaxTransactions', sortable: true },
  { title: 'Status', key: 'IsActive', sortable: true },
  { title: 'Ações', key: 'actions', sortable: false, align: 'center' }
]

const dialog = ref(false)
const formRef = ref(null)
const formValid = ref(false)
const isEditing = ref(false)
const saving = ref(false)
const form = ref({
  Code: '',
  Name: '',
  Description: '',
  Weight: 5,
  MinTransactions: 1,
  MaxTransactions: null,
  DisplayOrder: 1,
  IsActive: true
})

const rules = {
  required: v => !!v || 'Campo obrigatório',
  positive: v => v > 0 || 'Deve ser maior que zero'
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
      Code: '',
      Name: '',
      Description: '',
      Weight: 5,
      MinTransactions: 1,
      MaxTransactions: null,
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
      await store.update(form.value.UseCaseComplexityId, form.value)
      showSnackbar('Complexidade atualizada com sucesso!', 'success')
    } else {
      await store.create(form.value)
      showSnackbar('Complexidade criada com sucesso!', 'success')
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
    await store.remove(itemToDelete.value.UseCaseComplexityId)
    showSnackbar('Complexidade excluída com sucesso!', 'success')
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
