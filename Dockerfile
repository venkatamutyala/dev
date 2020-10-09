FROM ubuntu:20.04

RUN apt update && apt install -y \
    python3-pip \
    git \
    wget \
    curl
RUN pip3 install --upgrade awscli
RUN wget https://github.com/mozilla/sops/releases/download/v3.6.1/sops-v3.6.1.linux -O /usr/local/bin/sops \
    && chmod 0755 /usr/local/bin/sops \
    && chown root:root /usr/local/bin/sops

COPY --from=lachlanevenson/k8s-kubectl:v1.18.8 /usr/local/bin/kubectl /usr/local/bin/kubectl
#ADD https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.13/2020-08-04/bin/darwin/amd64/kubectl /usr/local/bin/kubectl
ADD https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.1/aws-iam-authenticator_0.5.1_linux_amd64 /usr/local/bin/aws-iam-authenticator
ADD https://github.com/argoproj/argo-cd/releases/download/v1.7.6/argocd-linux-amd64 /usr/local/bin/argocd
ADD https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz helm.tar.gz
RUN chmod +x /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/argocd
RUN tar -xvf helm.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm
#RUN helm plugin install https://github.com/jkroepke/helm-secrets
RUN curl -sLS https://dl.get-arkade.dev | sh


# #RUN aws --version && kubectl version --client
RUN useradd -ms /bin/bash kubectl
USER kubectl
WORKDIR /home/kubectl
RUN wget https://github.com/jkroepke/helm-secrets/releases/latest/download/helm-secrets.tar.gz -O helm-secrets.tar.gz
RUN mkdir -p .local/share/helm/plugins
RUN tar -xzf helm-secrets.tar.gz -C "/home/kubectl/.local/share/helm/plugins"  
#ENTRYPOINT [ "/usr/local/bin/kubectl.sh" ]
