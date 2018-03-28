from sklearn.externals import joblib

def classify(x):

    path = "clf.pkl"
    clf = joblib.load(path)
    pred = clf.predict(x)
    return pred,clf.classes_
