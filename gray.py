import pandas as pd
import numpy as np
from xgboost import XGBRegressor
from sklearn.model_selection import cross_val_score

bert = pd.read_csv("/mnt/c/Users/User/thesis_data/bert_kernel_features.csv")
resnet = pd.read_csv("/mnt/c/Users/User/thesis_data/resnet_kernel_features.csv")

CLASS_COL = "kernel_class"
CYCLE_COL = "cycles"

MODEL_A_FEATURES = [
    "grid_size",
    "block_size",
    "wave_count",
    "theoretical_occ",
    "warps_per_block"
]

MODEL_B_FEATURES = MODEL_A_FEATURES + [
    "warps_active_pct",
    "tensor_cycles_pct",
    "dram_throughput_pct",
    "stall_scoreboard_pct"
]

PARAMS = dict(
    n_estimators=400,
    max_depth=6,
    learning_rate=0.05,
    subsample=0.8,
    colsample_bytree=0.8,
    objective="reg:squarederror",
    random_state=42,
    n_jobs=-1
)

def evaluate_models(df, name):
    print(f"\n{'='*55}")
    print(f"WORKLOAD: {name}")
    print(f"{'='*55}")

    X_a = df[MODEL_A_FEATURES]
    X_b = df[MODEL_B_FEATURES]
    y   = df[CYCLE_COL]

    results = {}

    for label, X in [("Model A", X_a), ("Model B", X_b)]:
        model = XGBRegressor(**PARAMS)
        model.fit(X, y)
        train_r2 = model.score(X, y)

        cv_scores = cross_val_score(
            XGBRegressor(**PARAMS), X, y,
            cv=5, scoring="r2", n_jobs=-1
        )
        cv_r2  = cv_scores.mean()
        cv_std = cv_scores.std()

        results[label] = cv_r2

        print(f"\n  {label}")
        print(f"  Training R²  : {train_r2:.4f}")
        print(f"  CV R² (mean) : {cv_r2:.4f}")
        print(f"  CV R² (std)  : {cv_std:.4f}")
        print(f"  CV folds     : {cv_scores.round(4)}")

    delta = results["Model B"] - results["Model A"]
    print(f"\n  ΔR² (Model B - Model A) : {delta:.4f}")

for name, df in [("BERT-99", bert), ("ResNet-50", resnet)]:
    evaluate_models(df, name)
