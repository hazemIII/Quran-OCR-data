from sklearn.externals import joblib

def classify(x):

    path = "model/clf.pkl"
    clf = joblib.load(path)
    pred = clf.predict(x)
    return pred



