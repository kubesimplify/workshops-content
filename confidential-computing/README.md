## 01 Intro Confidential Computing (CC)

* [Confidential computing wiki](https://www.edgeless.systems/wiki/)
* [Confidential computing consortium](https://confidentialcomputing.io/)
* [OC3](https://www.oc3.dev/)
* [CCS](https://www.confidentialcomputingsummit.com/)
* [Talk: Kubernetes Meets Confidential Computing](https://www.youtube.com/watch?v=RTaXTgiP74c&t=1s&ab_channel=TheLinuxFoundation)

Alternative privacy-preserving technologies:

* [Homomorphic encryption](https://en.wikipedia.org/wiki/Homomorphic_encryption)
* [Secure multi-party Computation](https://en.wikipedia.org/wiki/Secure_multi-party_computation)
* [Federated Learning](https://en.wikipedia.org/wiki/Federated_learning)

### Confidential Computing Hardware

CPU:
* [Intel SGX](https://www.intel.de/content/www/de/de/products/docs/accelerator-engines/software-guard-extensions.html)
* [AMD SEV](https://www.amd.com/de/developer/sev.html)
* [Intel TDX](https://www.intel.com/content/www/us/en/developer/tools/trust-domain-extensions/overview.html)
* [ARM CCA](https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture)
* [RISC-V AP-TEE](https://github.com/riscv-non-isa/riscv-ap-tee/)
* [IBM Secure Execution](https://www.ibm.com/docs/en/linux-on-systems?topic=execution-components)

GPUs and accelerators:
* [NVIDIA Confidential Computing](https://www.nvidia.com/en-us/data-center/solutions/confidential-computing/)
* [TDISP](https://pcisig.com/tee-device-interface-security-protocol-tdisp)
* [AMD SEV-TIO](https://www.amd.com/system/files/documents/sev-tio-whitepaper.pdf)
* [Intel TDX Connect](https://cdrdv2-public.intel.com/772642/whitepaper-tee-io-device-guide-v0-6-5.pdf)


Trusted Execution Environments with different use cases or different properties:
* [ARM TrustZone](https://www.arm.com/technologies/trustzone-for-cortex-a)
* [Apple Secure Enclave](https://support.apple.com/guide/security/secure-enclave-sec59b0b31ff/web)

### Confidential computing offerings in the cloud

* [Azure Confidential Computing](https://azure.microsoft.com/en-us/solutions/confidential-compute)
* [AWS Nitro Platform](https://aws.amazon.com/de/blogs/security/confidential-computing-an-aws-perspective/)
* [AWS Confidential EC2 instances](https://docs.aws.amazon.com/de_de/AWSEC2/latest/UserGuide/sev-snp.html)
* [GCP Confidential Computing](https://cloud.google.com/security/products/confidential-computing?hl=en)
* [Constellation: Confidential Cluster](https://github.com/edgelesssys/constellation)

### Software foundations:

* [Linux Kernel Mailinglist linux-coco](https://lore.kernel.org/linux-coco/)
* [AMD SEV-SNP in Linux 6.11](https://www.phoronix.com/news/Linux-611-AMD-SEV-SNP-KVM-Guest)
* [Intel TDX Linux](https://github.com/intel/tdx-linux)


## 02 Intro Confidential Containers (CoCo)

* [Confidential Containers GitHub](https://github.com/confidential-containers)
* [CNCF Confidential Containers](https://www.cncf.io/projects/confidential-containers/)
* [Kata Containers](https://katacontainers.io/)
* [How Kubernetes creates and runs containers](https://www.redhat.com/architect/how-kubernetes-creates-runs-containers)
* [Cloud API adaptor](https://confidentialcontainers.org/docs/cloud-api-adaptor/)
* [RuntimeClass Operator](https://github.com/confidential-containers/operator)


## 03 Create CoCo-capable Kubernetes clusters

* [Azure CoCo Preview](https://learn.microsoft.com/en-us/azure/aks/confidential-containers-overview)
* [Create a CoCo-ready AKS cluster](https://docs.edgeless.systems/contrast/getting-started/cluster-setup)

## 04 Deploy Confidential Containers with Contrast

* [Contrast GitHub](https://github.com/edgelesssys/contrast)
* [Contrast Getting started](https://docs.edgeless.systems/contrast/getting-started/install)
* [Emoji voting example](https://docs.edgeless.systems/contrast/examples/emojivoto)
