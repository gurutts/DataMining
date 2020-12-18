# 1. Linear Model
# Training Data
x = c(3.0, 6.0, 3.0, 6.0, 7.5, 7.5, 15.0)
u = c(10.0, 10.0, 20.0, 20.0, 5.0, 10.0, 12.0)
y = c(4.65, 5.9, 6.7, 8.02, 7.7, 8.1, 6.1)

# Linear Model
m = lm(y ~ x + u)
coef(m)

# Test Data
nx = c(7.5, 5.0)
nu = c(15.0, 12.0)
new_data = data.frame(x = nx, u = nu)

# Predict
ny = predict(m , new_data)
ny

# Plotting
library(scatterplot3d)
s = scatterplot3d(nx, nu, ny, xlim = 0:14, ylim = 0:30, zlim = 0:14, pch = 20,
                  type = 'h', color = 'red', angle = 60)
s$plane3d(m)

# 2. Regression & Classification
# ���� �ۼ�

# 3. Overfitting
# ���� �ۼ�

# 4. Sensitivity & Specificity
df = data.frame(predict = c('N', 'N', 'P', 'N', 'P', 'P', 'N', 'N', 'N', 'P', 'N', 'P', 'N', 'N', 'N', 'P', 'P', 'N', 'P', 'P'),
                label = c('N', 'P', 'P', 'N', 'N', 'P', 'N', 'N', 'P', 'P', 'P', 'N', 'N', 'P', 'N', 'P', 'P', 'N', 'P', 'N'), stringsAsFactors = TRUE)

TP = 0
FP = 0
FN = 0
TN = 0

for(i in c(1:nrow(df))) {
  if(df$predict[i] == df$label[i]) {
    if(df$label[i] == 'P') {
      TP = TP + 1
    }
    else {
      TN = TN + 1
    }
  }
  else {
    if(df$label[i] == 'P') {
      FP = FP + 1
    }
    else {
      FN = FN + 1
    }
  }
}

print(paste("���е� : ", TP / (TP + FP), sep = ""))
print(paste("������ : ", TP / (TP + FN), sep = ""))
print(paste("Ư�̵� : ", TN / (FP + TN), sep = ""))
print(paste("�ΰ��� : ", TP / (TP + FN), sep = ""))

# 5. Apply Multiple Classification Models to UCLA Data
# 5-1. �����͸� ȹ���ϰ� ���� �����ϱ� ���� �غ����
ucla = read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")
ucla$admit = as.factor(ucla$admit)
str(ucla)

# 5-2. �н� �����Ϳ� �׽�Ʈ������ �и�����
library(caret)
train_list = createDataPartition(y = ucla$rank, p = 0.6, list = FALSE)
ucla_train = ucla[train_list, ]
ucla_test = ucla[-train_list, ]

# 5-3. �н������ͷ� ���� ����� ����(�𵨸�)
control = trainControl(method = 'cv', number = 5)
rp = train(admit ~ ., data = ucla_train, method = 'rpart',
           metric = 'Accuracy', trControl = control)
rf_50 = train(admit ~ ., data = ucla_train, method = 'rf', ntree = 50,
              metric = 'Accuracy', trControl = control)
rf_1000 = train(admit ~ ., data = ucla_train, method = 'rf', ntree = 1000,
                metric = 'Accuracy', trControl = control)
knn = train(admit ~ ., data = ucla_train, method = 'knn',
            metric = 'Accuracy', trControl = control)
svm_radial = train(admit ~ ., data = ucla_train, method = 'svmRadial',
                   metric = 'Accuracy', trControl = control)
svm_poly = train(admit ~ ., data = ucla_train, method = 'svmPoly',
                 metric = 'Accuracy', trControl = control)

# 5-4. �׽�Ʈ�����ͷ� �����ϰ�, ��������� ȥ����ķ� ����ϴ� ����
cm_list = list(rp, rf_50, rf_1000, knn, svm_radial, svm_poly)
for(i in cm_list) {
  p = predict(i, newdata = ucla_test)
  if(i$modelInfo$label == "Random Forest") {
    print(paste(i$modelInfo$label, " / ntree = ", i$dots$ntree, sep = ""))
  }
  else {
    print(i$modelInfo$label)
  }
  print(confusionMatrix(p, ucla_test$admit)$table)
  print(confusionMatrix(p, ucla_test$admit)$overall["Accuracy"])
}

# 5-5. ȥ����ķ� ���� ��Ȯ���� ����ϴ� ����
# ���� �ۼ�