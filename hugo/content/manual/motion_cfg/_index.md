+++
title = "Motion configuration"
weight = 8
chapter = false
+++

<a id="how-to-use-this-section"></a>

## Getting started

Configure physical and virtual axes with YAML. Start with a working stepper or servo example, then adapt it to your hardware.

If you want the preferred meaning of terms such as `axis`, `axis PLC`, and
`legacy motion`, see [Terminology]({{< relref "/manual/terminology.md" >}}).

For new configurations, the preferred path is YAML-based:

1. configure slaves with `addSlave.cmd` and `applyComponent.cmd`
2. load axes with `loadYamlAxis.cmd`
3. load PLC logic with `loadYamlPlc.cmd` or `loadPLCFile.cmd`

If you are maintaining an older IOC based on `.ax`, `.vax`, and `.sax` files,
go directly to [legacy motion]({{< relref "/manual/motion_cfg/legacy.md" >}}).

<!-- Preserve links to the former overview headings. -->
<a id="new-axis-bring-up"></a>
<a id="recommended-reading-paths"></a>

## Commission a new axis

1. Follow the [Quickstart]({{< relref "/manual/quickstart.md" >}}) and select a [motion example]({{< relref "/manual/motion_cfg/best_practice/_index.md" >}}).
2. Configure the axis with the [YAML guide]({{< relref "/manual/motion_cfg/axisYaml.md" >}}) and choose the [drive mode]({{< relref "/manual/motion_cfg/modes_CSV_CSP_CSP_PC.md" >}}).
3. Verify [scaling]({{< relref "/manual/motion_cfg/scaling.md" >}}) and [direction of motion]({{< relref "/manual/motion_cfg/direction.md" >}}).
4. Configure and verify [homing]({{< relref "/manual/motion_cfg/homing.md" >}}).
5. Configure [motor-record behavior]({{< relref "/manual/motion_cfg/motor.md" >}}) and [position and soft-limit autosave]({{< relref "/manual/motion_cfg/autosave.md" >}}) when needed.
6. Check [motion diagnostics]({{< relref "/manual/knowledgebase/motion.md" >}}) and [tuning]({{< relref "/manual/knowledgebase/tuning.md" >}}). Review the configuration warnings below before putting the IOC into service.

<!-- Preserve links to the former overview headings. -->
<a id="common-tasks"></a>
<a id="existing-ioc-with-classic-motion-files"></a>
<a id="key-references"></a>
<a id="runtime-tuning-and-diagnostics"></a>
<a id="synchronization-and-axis-logic"></a>
<a id="topics"></a>

## Find a topic

| Task | Guide |
| --- | --- |
| Look up YAML keys | [Settings table]({{< relref "/manual/motion_cfg/axisYamlSettingsTable.md" >}}) |
| See all settings in a configuration | [Complete axis YAML example]({{< relref "/manual/motion_cfg/axisYamlExample.md" >}}) |
| Configure motor-record examples and retry tests | [Motor record examples]({{< relref "/manual/motion_cfg/best_practice/motor.md" >}}) |
| Maintain classic `.ax`, `.vax`, or `.sax` files | [Legacy motion]({{< relref "/manual/motion_cfg/legacy.md" >}}); use the scaling, direction, homing, and motion diagnostics guides above as needed |
| Specialized motion, coordination, and runtime tools | [Advanced motion]({{< relref "/manual/motion_cfg/advanced.md" >}}) |
| Select a configuration backend | [ECB]({{< relref "/manual/motion_cfg/ecb.md" >}}) and [ECMCCOMP]({{< relref "/manual/motion_cfg/ecmccomp.md" >}}) |

<a id="configuration-warnings"></a>

See [Configuration warnings]({{< relref "/manual/motion_cfg/configuration_warnings.md" >}}) for detailed validation checks.
