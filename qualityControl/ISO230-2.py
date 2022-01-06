import re
import pandas as pd
import matplotlib.pyplot as plt
import yaml
from jinja2 import Template

'''
ISO230-2 data evaluation
Data has target positions 't[n]', with n>=5. type(n)==int, min(n)==1
These targets are approached by the device from the forward and backward direction at least 5 times.
The targets should be equidistantly spaces over the full stroke of the axis.
Thus, three sets of data will be treated, target positions 't' array, reference positions 'rFwd' and 'rBwd', matrix.

Procedure:
1. move to BwdLS
2. Forward run 1
    BwdLS||->1--->2--->3--->4--->5--||FwdLS
3. move to FwdLS
4. Backward run 1
    BwdLS||--1<---2<---3<---4<---5--||FwdLS
5. Start at '1.'
'''


class ISO230:
    def __init__(self):
        self.data = []
        self.targets = {}
        self.actualFwd = pd.DataFrame()
        self.actualBwd = pd.DataFrame()
        # mean unidirectional positional deviation
        self.deviation = pd.DataFrame()
        self.results = {}
        self.maxB = 0
        self.avgB = 0
        self.RFwd = 0
        self.RBwd = 0
        self.RAll = 0
        self.EFwd = 0
        self.EBwd = 0
        self.EAll = 0
        self.MAll = 0
        self.AFwd = 0
        self.ABwd = 0
        self.AAll = 0

    def __str__(self):
        str = f'ISO230-2 evaluator\n' \
              f'targets:\n' \
              f'{self.targets}\n' \
              f'actual forward:\n' \
              f'{self.actualFwd}\n' \
              f'actual backward:\n' \
              f'{self.actualFwd}\n' \
              f'deviation\n' \
              f'{self.deviation}\n' \
              f'==== Eval ====\n' \
              f'{yaml.dump(self.results)}\n' \
              f'{self.results}'
        return str

    def loadFile(self, fn):
        """
        load data file, skip over commented lines (#)
        remove all whitespaces
        strip new lines
        """
        with open(fn, 'r') as f:
            for l in f:
                if re.match(r'^#', l):
                    continue
                self.data.append(l.replace(' ', '').strip())

    def importData(self, fn):
        pass

    def parse(self, key):
        """
        parse data array for keyword and return all lines containing this key
        raise KeyError if key not found
        """
        result = []
        for l in self.data:
            if key in l:
                result.append(l)
        if len(result) == 0:
            raise KeyError(f'key >{key}< not found!')
        return result

    def getTargets(self):
        """
        obtain the array of target positions
        """
        targets = self.parse('TGT_DATA')
        for t in targets:
            match = re.match(r'TGT_DATA\[(\d*)\]=(.*)', t)
            if match:
                self.targets[int(match.group(1))] = float(match.group(2))

    @staticmethod
    def sortRefData(data):
        sorted_data = {}
        for k, v in sorted(data.items()):
            sorted_data[k] = dict(sorted(v.items()))
        return sorted_data

    def getRefData(self, dir='FWD'):
        dir = dir.upper()
        m = f'REF_DATA_{dir}'
        mr = m + r'\[(\d*),(\d*)\]=(.*)'
        ref = self.parse(m)
        data = {}
        for r in ref:
            match = re.match(mr, r)
            if match:
                i = int(match.group(1))
                i = self.targets[i]
                j = int(match.group(2))
                d = float(match.group(3))
                if i not in data:
                    data[i] = {}
                data[i][j] = d
        return self.sortRefData(data)

    def getReference(self, dir='ALL'):
        dir = dir.upper()
        if dir == 'ALL':
            self.getReference(dir='FWD')
            self.getReference(dir='BWD')
        elif dir == 'FWD':
            self.actualFwd = pd.DataFrame(data=self.getRefData(dir='FWD'))
        elif dir == 'BWD':
            self.actualBwd = pd.DataFrame(data=self.getRefData(dir='BWD'))
        else:
            raise NotImplementedError(f'direction >{dir}< not implemented!')

    def evalDeviation(self):
        # deviation from target
        deviationFwd = self.actualFwd - self.actualFwd.columns
        deviationBwd = self.actualBwd - self.actualBwd.columns
        # section 2.10
        self.deviation['xiFwd'] = deviationFwd.mean()
        self.deviation['xiBwd'] = deviationBwd.mean()
        # section 2.11
        self.deviation['xiAll'] = self.deviation[['xiFwd', 'xiBwd']].mean(axis=1)
        # absolute deviation, aka 'reversal', section 2.12
        absDev = self.actualFwd - self.actualBwd
        self.deviation['Bi'] = absDev.mean()
        # section 2.13
        self.results['maxB'] = self.deviation['Bi'].abs().max()
        # section 2.14
        self.results['avgB'] = self.deviation['Bi'].mean()
        # section 2.15
        self.deviation['siFwd'] = deviationFwd.std()
        self.deviation['siBwd'] = deviationBwd.std()
        # section 2.16
        self.deviation['RiFwd'] = 4 * deviationFwd.std()
        self.deviation['RiBwd'] = 4 * deviationBwd.std()
        # section 2.17
        df = pd.DataFrame()
        df['t1'] = 2 * self.deviation['siFwd'] + 2 * self.deviation['siBwd'] + self.deviation['Bi'].abs()
        df['t2'] = self.deviation['RiFwd']
        df['t3'] = self.deviation['RiBwd']
        self.deviation['RiAll'] = df.max(axis=1)
        # section 2.18
        self.results['RFwd'] = self.deviation['RiFwd'].max()
        self.results['RBwd'] = self.deviation['RiBwd'].max()
        # section 2.19
        self.results['RAll'] = self.deviation['RiAll'].max()
        # section 2.20
        self.results['EFwd'] = self.deviation['xiFwd'].max() - self.deviation['xiFwd'].min()
        self.results['EBwd'] = self.deviation['xiBwd'].max() - self.deviation['xiBwd'].min()
        # section 2.21
        self.results['EAll'] = self.deviation[['xiFwd', 'xiBwd']].max().max() - self.deviation[
            ['xiFwd', 'xiBwd']].min().min()
        # section 2.22
        self.results['MAll'] = self.deviation['xiAll'].max() - self.deviation['xiAll'].min()
        # section 2.23
        self.results['AFwd'] = (self.deviation['xiFwd'] + 2 * self.deviation['siFwd']).max() - \
                               (self.deviation['xiFwd'] - 2 * self.deviation['siFwd']).min()
        self.results['ABwd'] = (self.deviation['xiBwd'] + 2 * self.deviation['siBwd']).max() - \
                               (self.deviation['xiBwd'] - 2 * self.deviation['siBwd']).min()
        # section 2.24
        d = []
        d.append((self.deviation['xiFwd'] + 2 * self.deviation['siFwd']).max())
        d.append((self.deviation['xiBwd'] + 2 * self.deviation['siBwd']).max())
        d.append((self.deviation['xiFwd'] - 2 * self.deviation['siFwd']).min())
        d.append((self.deviation['xiBwd'] - 2 * self.deviation['siBwd']).min())
        self.results['AAll'] = max(d) - min(d)

    def boxPlot(self):
        rf = self.actualFwd - self.targets
        rb = self.actualBwd - self.targets
        res = pd.concat([rf, rb])

        # res.boxplot(by='X')
        print(res)
        res.boxplot()


if __name__ == "__main__":
    dat = ISO230()

    dat.loadFile('data/sampleData.dat')

    dat.getTargets()

    dat.getReference()

    dat.evalDeviation()

    # print(dat)

    print(dat.actualFwd)

    print(dat.actualBwd)

    t = Template('reversal of axis:  {{res.maxB|round(res.prec)}}\n'
                 'mean reversal:     {{res.avgB|round(res.prec)}}\n'
                 'repeatability fwd: {{res.RFwd|round(res.prec)}}\n'
                 'repeatability bwd: {{res.RBwd|round(res.prec)}}\n'
                 'repeatability max: {{res.RAll|round(res.prec)}}\n'
                 'E fwd:             {{res.EFwd|round(res.prec)}}\n'
                 'E bwd:             {{res.EBwd|round(res.prec)}}\n'
                 'E max:             {{res.EAll|round(res.prec)}}\n'
                 'M max:             {{res.MAll|round(res.prec)}}\n'
                 'accuracy fwd:      {{res.AFwd|round(res.prec)}}\n'
                 'accuracy bwd:      {{res.ABwd|round(res.prec)}}\n'
                 'accuracy max:      {{res.AAll|round(res.prec)}}')

    dat.results['prec']=6
    print(t.render(res=dat.results))

    # dat.actualFwd.columns=[2,4,6,8,10]
    # print(dat.actualFwd)
    # print(dat.deviation['xiFwd'])
    #
    # pdf = (dat.actualFwd - dat.targets).T
    # print(pdf)

    #
    # x=[]
    # for p in dat.actualFwd.columns:
    #     x.append(dat.targets[p])
    # pdf['x'] = x
    # ax = pdf.plot(x=pdf.index)
    # mdf = dat.deviation['xiFwd']
    # mdf['x'] = x
    # mdf.plot(x='x', ax=ax)
    # plt.show()

    # print( (dat.actualFwd - dat.actualBwd).mean() )
    # rel = dat.actualFwd - dat.targets
    # print(rel)
    # print(rel.mean())
    # dat.deviation['fwd'] = rel.mean()
    # print(dat.deviation)
    #
    # dat.getReference(dir='BWD')
    # print(dat.bwd)

    # res = pd.concat([dat.fwd, dat.bwd])
    # print(res)
    # res.boxplot()
    # dat.boxPlot()
    # plt.show()

    # # dat.fwd.plot()
    #
    # positions = []
    # for c in dat.bwd.columns:
    #     print(dat.targets[c])
    #     positions.append(dat.targets[c])
    #
    # plt.boxplot((dat.bwd - dat.targets),patch_artist=True, positions=positions)
    #
    # plt.boxplot((dat.fwd - dat.targets), positions=positions)
    #
    # (dat.bwd - dat.targets).boxplot(positions=positions)
    # plt.show()
