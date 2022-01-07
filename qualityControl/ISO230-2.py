import re
import pandas as pd
import matplotlib.pyplot as plt
import yaml
from jinja2 import Template

import numpy as np
import prepSampleData

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
        self.parameters = {}
        self.actualFwd = pd.DataFrame()
        self.actualBwd = pd.DataFrame()
        self.deviation = pd.DataFrame()
        self.results = {}

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

    def evalDeviation(self, k=2):
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
        '''
            data for plotting
        '''
        self.deviation['ciuFwd'] = self.deviation['xiFwd'] + k * self.deviation['siFwd']
        self.deviation['cilFwd'] = self.deviation['xiFwd'] - k * self.deviation['siFwd']
        self.deviation['ciuBwd'] = self.deviation['xiBwd'] + k * self.deviation['siBwd']
        self.deviation['cilBwd'] = self.deviation['xiBwd'] - k * self.deviation['siBwd']

    def boxPlot(self,
                factor=1000,
                title='boxplot of bi-directional positioning',
                x_label='target position (mm)',
                y_label='deviation from target (um)'):
        rf = (self.actualFwd - self.actualFwd.columns) * factor
        rb = (self.actualBwd - self.actualBwd.columns) * factor
        res = pd.concat([rf, rb])

        bplot = res.boxplot()
        bplot.set_title(title)
        bplot.set_xlabel(x_label)
        bplot.set_ylabel(y_label)

    def ISO230Plot(self, factor=1000, k=2,
                   title='Bi-directional accuracy and repeatability of positioning',
                   x_label='target position (mm)',
                   y_label=r'deviation from target $\left(\mu m\right)$'):

        # raw data, deviation from target position
        rf = (self.actualFwd - self.actualFwd.columns) * factor
        rb = (self.actualBwd - self.actualBwd.columns) * factor
        # mean deviation
        x_fwd = self.deviation['xiFwd'] * factor
        x_bwd = self.deviation['xiBwd'] * factor
        x_mean = self.deviation['xiAll'] * factor
        # confidence interval with coverage factor k
        conf = self.deviation[['ciuFwd', 'cilFwd', 'ciuBwd', 'cilBwd']] * factor
        # weird 'hiding from legend' hack. Causes matplotlib warning
        cols = ["_" + col for col in conf.columns]
        cols[0] = r'$\bar{x}\uparrow\pm2s\uparrow \textnormal{or~} \bar{x}\downarrow\pm2s\downarrow$'
        conf.columns = cols

        # actual plotting
        plt.rcParams['text.usetex'] = True  # use LaTeX for nice typesetting
        fig, ax = plt.subplots()
        ax.set_title(title)
        ax.set_xlabel(x_label)
        ax.set_ylabel(y_label)

        # raw data, deviation from target position
        rf.T.plot(ax=ax, style='o', fillstyle='none', markersize=5)
        rb.T.plot(ax=ax, style='s', fillstyle='none', markersize=5)
        # mean deviation
        x_fwd.plot(ax=ax, label=r'$\bar{x}\uparrow$', style='k--')
        x_bwd.plot(ax=ax, label=r'$\bar{x}\downarrow$', style='k--')
        x_mean.plot(ax=ax, label=r'$\bar{x}$', style='k-', linewidth=2)
        # confidence intervals
        conf.plot(ax=ax, style='k-.', linewidth=1)
        # get rid of 'i' in legend
        h, l = plt.gca().get_legend_handles_labels()
        labels = dict(zip(l, h))
        labels = {i: labels[i] for i in labels if not i.isnumeric()}
        plt.legend(labels.values(), labels.keys())


if __name__ == "__main__":
    data_file = 'data/sampleData.txt'

    '''
    redeclare 'offset'
    '''
    class MyData(prepSampleData.ISO230_2_Data):
        def offset(self, p):
            x = p / max(self.range) * 1 * np.pi
            return np.sin(x) * self.reversal


    prepData = MyData(i=11, j=23, axis_range=[-100, 100], reversal=.5, target_sigma=0.1, pos_sigma=0.1)
    prepData.createData()
    prepData.writeData('data/sampleData.txt')

    dat = ISO230()

    dat.loadFile(data_file)

    dat.getTargets()

    dat.getReference()

    dat.evalDeviation()

    dat.ISO230Plot()
    plt.show()

    t = Template('reversal of axis:  {{res.maxB|round(par.prec|default(5))}}\n'
                 'mean reversal:     {{res.avgB|round(par.prec|default(5))}}\n'
                 'repeatability fwd: {{res.RFwd|round(par.prec|default(5))}}\n'
                 'repeatability bwd: {{res.RBwd|round(par.prec|default(5))}}\n'
                 'repeatability max: {{res.RAll|round(par.prec|default(5))}}\n'
                 'E fwd:             {{res.EFwd|round(par.prec|default(5))}}\n'
                 'E bwd:             {{res.EBwd|round(par.prec|default(5))}}\n'
                 'E max:             {{res.EAll|round(par.prec|default(5))}}\n'
                 'M max:             {{res.MAll|round(par.prec|default(5))}}\n'
                 'accuracy fwd:      {{res.AFwd|round(par.prec|default(5))}}\n'
                 'accuracy bwd:      {{res.ABwd|round(par.prec|default(5))}}\n'
                 'accuracy max:      {{res.AAll|round(par.prec|default(5))}}')
    print(t.render(res=dat.results, par=dat.parameters))
