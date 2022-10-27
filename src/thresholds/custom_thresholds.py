def neutral_threshold(x, neutral_label, threshold=0.05):
    """
    Neutral threshold function for manually selecting the
    probability threshold for the neutral class
    instead of just selecting the classes with the highest probability
    """

    label = None
    if x[neutral_label] >= threshold:
        label = neutral_label
    else:
        label = x.index[list(x).index(max(x))]
    return label


def restrictive_threshold(x, unclassified_label, threshold=0.9):
    label = None
    if max(x) >= threshold:
        label = x.index[list(x).index(max(x))]
    else:
        label = unclassified_label
    return label


def selected_labels_threshold(x, unclassified_label, selected_classes, threshold=0.9):
    label = None
    if (max(x) >= threshold) | (x.index[list(x).index(max(x))] not in selected_classes):
        label = x.index[list(x).index(max(x))]
    else:
        label = unclassified_label
    return label
