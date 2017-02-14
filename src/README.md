## How to use it

### Installation Dependencies

`Java`, `R`, R packages `tidyverse`, `plyr`, and `stringr`, and the Multi-worm Tracker 
Analysis software (`Chore.jar`) as a shell script in the executable path named `Chore`. 
To "easily" do this on a Mac or Linux OS, please follow the following installation 
instructions:

#### For Mac OSX
1. Install Homebrew by typing the following into the command line:

	`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
	
	
2. Install the Multi-worm Tracker Analysis software via Homebrew to install Chore.jar and
have it accesible as a shell script in the executable path named "Chore":
	`brew install homebrew/science/multi-worm-tracker`


#### For Linux
1. Install Linuxbrew by typing the following into the command line:

	`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"`


2. Put brew in your executable path by adding the commands below to either `.bashrc` or 
`.zshrc`: 
	~~~
	export PATH="$HOME/.linuxbrew/bin:$PATH"
	export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
	export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
	~~~

3. Install the Multi-worm Tracker Analysis software via Homebrew to install Chore.jar and
	have it accesible as a shell script in the executable path named "Chore":
	`brew install homebrew/science/multi-worm-tracker`


### Running the analysis

* Put your all your MWT experiment folders (zipped or unzipped) inside a single directory (no sub-directories)

* In the Unix Shell/terminal run the `call_chore.sh` script as shown below. It requires the following arguments from the user: 
(1) gigabytes of memory to be used to run Choreography (dependent upon the machine you are 
using), (2) relative path to the directory where your data is stored (e.g., `data/Experiment_1`).

~~~
bash src/call_chore.sh 4 data/Experiment_1
~~~
