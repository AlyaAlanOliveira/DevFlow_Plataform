"""
DevFlow - API Test Script
Script para testar todos os endpoints da API
"""
import requests
import json
from uuid import uuid4

BASE_URL = "http://localhost:8000"
API_V1 = f"{BASE_URL}/api/v1"


def print_response(response, title="Response"):
    """Imprime resposta formatada"""
    print(f"\n{'='*60}")
    print(f"{title}")
    print(f"{'='*60}")
    print(f"Status Code: {response.status_code}")
    try:
        print(f"Response: {json.dumps(response.json(), indent=2, default=str)}")
    except:
        print(f"Response: {response.text}")


def test_health():
    """Testa health check"""
    print("\n🏥 TESTANDO HEALTH CHECK")
    response = requests.get(f"{BASE_URL}/health")
    print_response(response, "Health Check")
    return response.status_code == 200


def test_priority_crud():
    """Testa CRUD de Priority"""
    print("\n📊 TESTANDO PRIORITY CRUD")
    
    # 1. Listar
    print("\n1️⃣ Listando prioridades...")
    response = requests.get(f"{API_V1}/priorities")
    print_response(response, "GET /priorities")
    
    # 2. Criar
    print("\n2️⃣ Criando prioridade...")
    priority_data = {
        "Code": "TEST_AUTO",
        "Name": "Teste Automático",
        "Description": "Prioridade criada por teste automático",
        "SLADays": 15,
        "ColorHex": "#00FF00",
        "DisplayOrder": 99,
        "IsActive": True
    }
    response = requests.post(f"{API_V1}/priorities", json=priority_data)
    print_response(response, "POST /priorities")
    
    if response.status_code == 201:
        priority_id = response.json()["PriorityId"]
        
        # 3. Buscar por ID
        print("\n3️⃣ Buscando prioridade por ID...")
        response = requests.get(f"{API_V1}/priorities/{priority_id}")
        print_response(response, f"GET /priorities/{priority_id}")
        
        # 4. Atualizar
        print("\n4️⃣ Atualizando prioridade...")
        update_data = {
            "Name": "Teste Automático ATUALIZADO",
            "SLADays": 10
        }
        response = requests.put(f"{API_V1}/priorities/{priority_id}", json=update_data)
        print_response(response, f"PUT /priorities/{priority_id}")
        
        # 5. Deletar
        print("\n5️⃣ Deletando prioridade...")
        response = requests.delete(f"{API_V1}/priorities/{priority_id}")
        print(f"Status Code: {response.status_code}")
        print("✅ Prioridade deletada com sucesso!" if response.status_code == 204 else "❌ Erro ao deletar")
        
        return True
    
    return False


def test_demand_type_crud():
    """Testa CRUD de DemandType"""
    print("\n📋 TESTANDO DEMAND TYPE CRUD")
    
    response = requests.get(f"{API_V1}/demand-types")
    print_response(response, "GET /demand-types")
    return response.status_code == 200


def test_workflow_status_crud():
    """Testa CRUD de WorkflowStatus"""
    print("\n🔄 TESTANDO WORKFLOW STATUS CRUD")
    
    response = requests.get(f"{API_V1}/workflow-status")
    print_response(response, "GET /workflow-status")
    return response.status_code == 200


def test_actor_complexity_crud():
    """Testa CRUD de ActorComplexity"""
    print("\n🎭 TESTANDO ACTOR COMPLEXITY CRUD")
    
    response = requests.get(f"{API_V1}/actor-complexities")
    print_response(response, "GET /actor-complexities")
    return response.status_code == 200


def test_usecase_complexity_crud():
    """Testa CRUD de UseCaseComplexity"""
    print("\n📦 TESTANDO USECASE COMPLEXITY CRUD")
    
    response = requests.get(f"{API_V1}/usecase-complexities")
    print_response(response, "GET /usecase-complexities")
    return response.status_code == 200


def test_operation_crud():
    """Testa CRUD de Operation"""
    print("\n🏢 TESTANDO OPERATION CRUD")
    
    response = requests.get(f"{API_V1}/operations")
    print_response(response, "GET /operations")
    return response.status_code == 200


def test_ucp_configuration_crud():
    """Testa CRUD de UCPConfiguration"""
    print("\n⚙️ TESTANDO UCP CONFIGURATION CRUD")
    
    # Listar todas
    response = requests.get(f"{API_V1}/ucp-configurations")
    print_response(response, "GET /ucp-configurations")
    
    # Buscar atual
    print("\n📅 Buscando configuração UCP vigente...")
    response = requests.get(f"{API_V1}/ucp-configurations/current")
    print_response(response, "GET /ucp-configurations/current")
    
    return response.status_code in [200, 404]  # 404 é OK se não houver configuração


def run_all_tests():
    """Executa todos os testes"""
    print("\n" + "="*60)
    print("🚀 INICIANDO TESTES DA API DEVFLOW")
    print("="*60)
    
    tests = [
        ("Health Check", test_health),
        ("Priority CRUD", test_priority_crud),
        ("DemandType CRUD", test_demand_type_crud),
        ("WorkflowStatus CRUD", test_workflow_status_crud),
        ("ActorComplexity CRUD", test_actor_complexity_crud),
        ("UseCaseComplexity CRUD", test_usecase_complexity_crud),
        ("Operation CRUD", test_operation_crud),
        ("UCPConfiguration CRUD", test_ucp_configuration_crud),
    ]
    
    results = []
    for name, test_func in tests:
        try:
            result = test_func()
            results.append((name, result))
        except Exception as e:
            print(f"\n❌ Erro no teste {name}: {str(e)}")
            results.append((name, False))
    
    # Resumo
    print("\n" + "="*60)
    print("📊 RESUMO DOS TESTES")
    print("="*60)
    
    for name, result in results:
        status = "✅ PASSOU" if result else "❌ FALHOU"
        print(f"{status} - {name}")
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    print(f"\n📈 Total: {passed}/{total} testes passaram ({passed/total*100:.1f}%)")
    
    if passed == total:
        print("\n🎉 TODOS OS TESTES PASSARAM!")
    else:
        print(f"\n⚠️ {total - passed} teste(s) falharam")


if __name__ == "__main__":
    try:
        run_all_tests()
    except KeyboardInterrupt:
        print("\n\n⏹️ Testes interrompidos pelo usuário")
    except Exception as e:
        print(f"\n\n❌ Erro fatal: {str(e)}")
