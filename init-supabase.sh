CONN="postgresql://postgres.zmmsrbwhshaxrtchcwxx:APvOAN!cW!i1pu@aws-0-us-west-2.pooler.supabase.com:5432/postgres"

docker run --rm -v "$(pwd):/scripts" postgres:16 psql "$CONN" -c "CREATE EXTENSION IF NOT EXISTS vector;"

for pasta in schema functions Triggers; do
  for arquivo in $pasta/*.sql; do
    echo "Aplicando $arquivo..."
    docker run --rm -v "$(pwd):/scripts" postgres:16 psql "$CONN" -f "/scripts/$arquivo"
  done
done