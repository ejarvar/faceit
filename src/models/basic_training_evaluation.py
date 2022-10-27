import pandas as pd
from sklearn.metrics import (
    ConfusionMatrixDisplay,
    confusion_matrix,
    classification_report,
)
from sklearn.model_selection import train_test_split
from sklearn.utils.class_weight import compute_sample_weight
from xgboost import XGBClassifier
from sklearn.preprocessing import LabelEncoder


def simple_model(
    X: pd.DataFrame,
    y: pd.Series,
    label_enc: LabelEncoder,
    random_state=42,
    sample_weight=False,
):
    """
    Simple xgboost model with default parameters
    That plots the confusion matrixes
    """

    xgb = XGBClassifier(n_estimators=100)

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=random_state
    )

    y_train_enc = label_enc.transform(y_train)
    y_test_enc = label_enc.transform(y_test)

    if sample_weight:
        sample_weights = compute_sample_weight(class_weight="balanced", y=y_train)
        xgb.fit(X_train, y_train_enc, sample_weight=sample_weights)

    else:
        xgb.fit(X_train, y_train_enc)
    pred = xgb.predict(X_test)

    cm = confusion_matrix(y_test_enc, pred)
    disp = ConfusionMatrixDisplay(
        confusion_matrix=cm, display_labels=label_enc.classes_
    )
    disp = disp.plot(xticks_rotation=90)

    cm = confusion_matrix(y_test_enc, pred, normalize="true")
    disp = ConfusionMatrixDisplay(
        confusion_matrix=cm, display_labels=label_enc.classes_
    )
    disp = disp.plot(xticks_rotation=90)

    return xgb, X_test, y_test
