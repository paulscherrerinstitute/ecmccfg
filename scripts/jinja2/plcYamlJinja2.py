import ecmcPlcYaml
import ecmcRenderJinja2

if __name__ == '__main__':
    plc = ecmcPlcYaml.EcmcPlc()
    plc.loadPlcConfig()
    print(plc.debug())
    ecmcRenderJinja2.renderTemplate(plc.template, plc.data, plc.outFile)
