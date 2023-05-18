<p align="center">
  <img width="200" src="https://raw.githubusercontent.com/HooverHigh/.github/main/assets/HooverHS.png" alt="Hoover high logo" align="center">
</p>

<h1 align="center">hhs-os</h1>

<p align="center">
  The main repository that downloads the other libraries and repositories for building HHSOS.
</p>
<p>To get started with hhs-os, follow these steps:</p>
<ol>
  <li>Clone the repository:</li>
</ol>

```bash
git clone https://github.com/hooverhigh/hhs-os.git
```
<ol start="2">
  <li>Run <code>setup.sh</code> script:</li>
</ol>

```bash
cd hhs-os
./setup.sh
```
<p>This will download all the necessary dependencies and set up the project for building.</p>
<p>To build the OS, run <code>create-os.sh</code> script with your OS build configuration, for example:</p>

```bash
#Build bullseye OS
./create-os.sh -c hhos/confs/HHSOS-BULLSEYE

#Build buster OS
./create-os.sh -c hhos/confs/HHSOS-BUSTER
```
