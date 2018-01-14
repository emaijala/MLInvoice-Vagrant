MLInvoice Vagrant
=================

This repository provides an [MLInvoice](https://github.com/emaijala/MLinvoice) setup on a basic Ubuntu linux virtual machine. It can be used to easily install MLInvoice for testing or further use on any computer that supports Vagrant.

Vagrant is an application that configures a virtual machine according to the given settings. In practice an Ubuntu Linux installation is created in a Virtualbox virtual machine and MLInvoice is automatically installed into it.

All applications apart from the prerequisites are installed in the virtual machine, which means the actual machine including its operating system settings and applications is kept intact.

*N.B.* All the crucial files for MLInvoice and it's database are stored in *data* directory under the directory where this package is extracted.

Prerequisites
-------------

- Enough disk space for the Ubuntu installation package and the actual installation. Maybe ~1.5 gigabytes.
- Internet connection so that Vagrant can download the required files. A fast connection helps for a fast installation.
- [Virtualbox](https://www.virtualbox.org/) (VMWare should work too but hasn't been tested)
- [Vagrant](https://www.vagrantup.com/)
- Basic command prompt (terminal) usage

Installation
------------

1. Install the prerequisites.
2. Download this repository as a zip file: https://github.com/emaijala/MLInvoice-Vagrant/archive/master.zip
3. Unpack the zip file somewhere. Note that this place will be permanent, and you need to find it in the command line. The following steps assume it's a Windows machine and the location is C:\MLInvoice.
4. Open Command Prompt: In Windows, bring up the Start menu and enter "command" ("komento" in Finnish) to search for it. Click when found.
5. Navigate to the forementioned directory by typing the following commands:

       c:
       cd \MLInvoice

6. Initialize the virtual machine:

       vagrant up

7. Vagrant will download required files, install the Linux box and MLInvoice and configure everything for you. This may take a good while depending on the speed of the internet connection and the computer.
8. When the installation is completed, navigate to http://localhost:8888/ to start using MLInvoice (default username and password is admin).
9. If you want to stop the virtual machine, run the following command:

       vagrant halt

    You can also use Virtualbox's control panel to stop the virtual machine.

10. Note that every time the computer is shut down or restarted, the virtual machine needs to be started for MLInvoice to be accessible. This can be done in the control panel for Virtualbox or using the `vagrant up` command like before.

11. If you want to get rid of MLInvoice, destroy the virtual machine:

        vagrant destroy

    Then you can remove the files and the MLInvoice directory. Please note that the data directory under the MLInvoice directory contains MLInvoice's MySQL database, which in turn contains all the data stored in MLInvoice. If this directory is deleted, all the data in MLInvoice will be lost.

Configuration
-------------

While the virtual machine comes ready to go, you may need to configure some of the MLInvoice settings found in config.php file. This is especially for making sending email work properly. After the installation is complete, MLInvoice's files are found in data/mlinvoice directory. See https://www.labs.fi/mlinvoice_installation.eng.php for more information about the configuration and https://www.labs.fi/mlinvoice_usage.eng.php for information on how to get started.
