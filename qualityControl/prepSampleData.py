import numpy as np


class ISO230_2_Data:
    def __init__(self, i=5, j=5, axis_range=None, reversal=0.1, target_sigma=0, pos_sigma=None):
        self.i = i
        self.j = j
        self.range = [-1, 1] if axis_range is None else axis_range
        self.target_sigma = target_sigma
        self.reversal = reversal
        self.pos_sigma = (max(self.range) - min(self.range)) / 10 if pos_sigma is None else pos_sigma
        self.targets = None
        self.data = {}

    def offset(self, p):
        x = p / max(self.range) * 2 * np.pi
        return np.sin(x) * self.reversal / 2

    def createData(self):
        pos = np.linspace(self.range[0], self.range[1], self.j)
        self.targets = np.random.normal(pos, self.target_sigma)
        self.data['FWD'] = [np.random.normal(t + self.reversal + self.offset(t), self.pos_sigma, self.i) for t in
                            self.targets]
        self.data['BWD'] = [np.random.normal(t - self.reversal + self.offset(t), self.pos_sigma, self.i) for t in
                            self.targets]

    def writeData(self, fn):
        with open(fn, 'w') as f:
            for i, t in enumerate(self.targets):
                target_key = f'TGT_DATA[{i + 1}] = {t}\n'
                f.write(target_key)
                for dir in self.data.keys():
                    for j, p in enumerate(self.data[dir][i]):
                        key = f'REF_DATA_{dir}[{i + 1},{j + 1}]={p}\n'
                        f.write(key)


if __name__ == '__main__':
    mydata = ISO230_2_Data(i=5, j=5, axis_range=[-10, 10], reversal=1, target_sigma=1, pos_sigma=0.1)

    mydata.createData()

    mydata.writeData('data/sampleData.txt')
