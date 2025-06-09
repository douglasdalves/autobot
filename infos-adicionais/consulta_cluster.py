import subprocess

def run_aws_cli_command(command):
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        return f"Erro ao executar o comando: {e.stderr.strip()}"

def main():
    region = input("Informe a região AWS (ex: us-east-1): ").strip()

    print(f"\n🔍 Verificando clusters EKS na região {region}...")
    eks_output = run_aws_cli_command(f"aws eks list-clusters --region {region} --output json")
    print("Clusters EKS encontrados:")
    print(eks_output)

    print(f"\n🔍 Verificando clusters MSK padrão na região {region}...")
    msk_output = run_aws_cli_command(f"aws kafka list-clusters --region {region} --output json")
    print("Clusters MSK padrão encontrados:")
    print(msk_output)

    print(f"\n🔍 Verificando clusters MSK Serverless na região {region}...")
    msk_v2_output = run_aws_cli_command(f"aws kafka list-clusters-v2 --region {region} --output json")
    print("Clusters MSK Serverless encontrados:")
    print(msk_v2_output)

if __name__ == "__main__":
    main()
