# %%
import torch as th
import torch.nn as nn
import pandas as pd
from os import mkdir
from shutil import copyfile, copytree
from torchvision import datasets, transforms
import matplotlib.pyplot as plt
from tqdm import tqdm
import numpy as np

# %%

train_transformation = transforms.Compose([
    transforms.ToTensor(),
    transforms.RandomCrop(50, 4),
])

train_dataset = datasets.ImageFolder (
    root="Data/train",
    transform=train_transformation,
)

train_loader = th.utils.data.DataLoader(
    train_dataset, batch_size=64, shuffle=True
)

validation_transformation = transforms.Compose([
    transforms.ToTensor(),
])

validation_dataset = datasets.ImageFolder (
    root="Data/validation",
    transform=train_transformation,
)

validation_loader = th.utils.data.DataLoader(
    validation_dataset, batch_size=64, shuffle=True
)

# %%

class Network(nn.Module):
    def __init__(self):
        super().__init__()

        self.net = nn.Sequential(
            nn.Conv2d(3, 32, 3, padding=1),
            nn.ReLU(),
            nn.BatchNorm2d(32),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 64, 3, padding=1),
            nn.ReLU(),
            nn.BatchNorm2d(64),
            nn.MaxPool2d(2),

            nn.Flatten(),

            nn.Linear(64 * 12 * 12, 1000),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(1000, 200),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(200, 3),
        )

    def forward(self, x):
        return self.net(x)
         
# %%

def train_one_epoch():
    net.train()

    avg_loss = 0.
    for images, labels in tqdm(train_loader):
        images = images.cuda()
        labels = labels.cuda()

        predictions = net(images)
        loss = criterion(predictions, labels)
        avg_loss += loss.item()
        loss.backward()
        optimizer.step()
    return avg_loss / len(train_loader)

def test_data(data_loader):
    net.eval()

    with th.no_grad():
        hit = 0
        total = 0
        avg_loss = 0.
        for images, labels in tqdm(data_loader):
            images = images.cuda()
            labels = labels.cuda()

            predictions = net(images)
            loss = criterion(predictions, labels)
            avg_loss += loss.item()
            hit += th.sum(labels == predictions.argmax(dim=1))
            total += len(images)

        return (hit / total, avg_loss / len(data_loader))

def print_confussion_matrix(data_loader):
    ans = [[0 for i in range(3)] for j in range(3)]
    with th.no_grad():
        for images, labels in tqdm(data_loader):
            images = images.cuda()
            labels = labels.cuda()

            predictions = net(images)
            prediction = predictions.argmax(dim=1)
            for i in range(len(labels)):
                ans[labels[i].item()][prediction[i].item()] += 1
    
    plt.imshow(ans, cmap='gray')
    print(np.array(ans))


# %%

# definim datele
net = Network().cuda()
criterion = nn.CrossEntropyLoss().cuda()
loss_hist = []

# %%

optimizer = th.optim.Adam(net.parameters(), lr=1e-5)

for epoch in range(20):
    loss = train_one_epoch()
    print(f"Loss: {loss}")
    loss_hist.append(loss)
    

# %%