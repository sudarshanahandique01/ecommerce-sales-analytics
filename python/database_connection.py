from sqlalchemy import create_engine

username = "postgres"
password = "C0ncentr@te"
host = "localhost"
port = "5433"
database = "ecommerce_analysis"

engine = create_engine(
    f"postgresql://{username}:{password}@{host}:{port}/{database}"
)

print("Database connected successfully!")