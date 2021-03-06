library(caret)
control = trainControl(method = 'cv', number = 5)
r = train(Species ~ ., data = iris, method = 'rpart',
          metric = 'Accuracy', trControl = control)
f = train(Species ~ ., data = iris, method = 'rf',
          metric = 'Accuracy', trControl = control)
s = train(Species ~ ., data = iris, method = 'svmRadial',
          metric = 'Accuracy', trControl = control)
k = train(Species ~ ., data = iris, method = 'knn',
          metric = 'Accuracy', trControl = control)
resamp = resamples(list(����Ʈ�� = r, ����������Ʈ = f, SVM = s, kNN = k))
summary(resamp)

sort(resamp, decreasing = TRUE)
dotplot(resamp)

control = trainControl(method = 'cv', number = 10)
r = train(Species ~ ., data = iris, method = 'rpart',
          metric = 'Accuracy', trControl = control)
f10 = train(Species ~ ., data = iris, method = 'rf', ntree = 10,
            metric = 'Accuracy', trControl = control)
f100 = train(Species ~ ., data = iris, method = 'rf', ntree = 100,
             metric = 'Accuracy', trControl = control)
f300 = train(Species ~ ., data = iris, method = 'rf', ntree = 300,
             metric = 'Accuracy', trControl = control)
s_Radial = train(Species ~ ., data = iris, method = 'svmRadial',
                 metric = 'Accuracy', trControl = control)
s_Polynomial = train(Species ~ ., data = iris, method = 'svmPoly',
                 metric = 'Accuracy', trControl = control)
k = train(Species ~ ., data = iris, method = 'knn',
          metric = 'Accuracy', trControl = control)

resamp = resamples(list(
  ����Ʈ�� = r, ��������10 = f10, ��������100 = f100, ��������300 = f300,
  SVMRadial = s_Radial, SVMPolynomial = s_Polynomial, kNN = k))
summary(resamp)
sort(resamp, decreasing = TRUE)
dotplot(resamp)

# Assignment
df = data.frame(predict = c('N', 'N', 'P', 'N', 'P', 'N', 'P', 'N', 'N', 'N', 'P', 'N'),
                label = c('P', 'N', 'N', 'N', 'P', 'N', 'P', 'N', 'P', 'N', 'N', 'P'), stringsAsFactors = TRUE)

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
