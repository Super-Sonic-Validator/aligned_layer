package chainio

import (
	"github.com/yetanotherco/aligned_layer/core/config"

	"github.com/Layr-Labs/eigensdk-go/chainio/clients"
	sdkavsregistry "github.com/Layr-Labs/eigensdk-go/chainio/clients/avsregistry"
	"github.com/Layr-Labs/eigensdk-go/logging"
)

type AvsReader struct {
	sdkavsregistry.AvsRegistryReader
	AvsContractBindings *AvsServiceBindings
	logger              logging.Logger
}

func NewAvsReaderFromConfig(c *config.Config) (*AvsReader, error) {

	buildAllConfig := clients.BuildAllConfig{
		EthHttpUrl:                 c.EthRpcUrl,
		EthWsUrl:                   c.EthWsUrl,
		RegistryCoordinatorAddr:    c.AlignedLayerRegistryCoordinatorAddr.String(),
		OperatorStateRetrieverAddr: c.AlignedLayerOperatorStateRetrieverAddr.String(),
		AvsName:                    "AlignedLayer",
		PromMetricsIpPortAddress:   c.EigenMetricsIpPortAddress,
	}

	clients, _ := clients.BuildAll(buildAllConfig, c.EcdsaPrivateKey, c.Logger)

	avsRegistryReader := clients.AvsRegistryChainReader

	avsServiceBindings, err := NewAvsServiceBindings(c.AlignedLayerServiceManagerAddr, c.AlignedLayerOperatorStateRetrieverAddr, c.EthHttpClient, c.Logger)
	if err != nil {
		return nil, err
	}

	return &AvsReader{
		AvsRegistryReader:   avsRegistryReader,
		AvsContractBindings: avsServiceBindings,
		logger:              c.Logger,
	}, nil
}
