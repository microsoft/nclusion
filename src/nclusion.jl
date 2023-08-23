module nclusion

    # Write your package code here.

    using Distributions
    using StatsBase, StatsFuns, StatsModels, StatsPlots, Statistics, LinearAlgebra, HypothesisTests,SpecialFunctions
    using Optim
    using Flux
    using DataFrames
    using JSON, JSON3
    using Dates
    using TSne, MultivariateStats, Clustering
    using OrderedCollections
    using CSV
    using LaTeXStrings, TypedTables, PrettyTables
    using JLD2,FileIO
    using Random
    using Test
    using Gnuplot, Colors, ColorSchemes
    using BenchmarkTools
    using Profile
    using HDF5
    using ClusterValidityIndices
    using StaticArrays
    using Pkg
    using Distributed
    using Distances
    using Logging
    using Base.Threads

    import Debugger

    curr_dir = ENV["PWD"]
    src_dir = "/src/"

    export @name, 
        naming_vec,
    #    set_current_value,
        addToDict!,
        addToOrderedDict!,
        generate_modelStatisticsFromDataFrame,
        generate_LabelInfoFromMetaDataFrame,
        generate_modelInputsFromDataFrames,
        getExperimentVariablesString, 
        get_unique_time_id,
        nested_dict_to_json,
        nested_dict_to_json3_with_name,
        append_to_json,generate_json_filename, 
        generate_filenameBase, 
        generate_filenameBase_closure, 
        generate_dirname, 
        json_to_dict,json3_to_dictstruct, 
        makeRelabellingOutputDirectories,
        makeGenericOutputDirectories,
        makeTidyOutputDirectories,
        saveInitializationFile,
        create_benchmark_summarization_file,
        save_run,
        setup_experiment_tag


    export raghavan2021_lognormalization,
            recursive_flatten,
            outermelt, 
            innermelt,
            IndexCounter,
            increment!,
            getCount

    export   t_test,norm_weights,normToProb,norm_weights3,norm_weights3!, normToProb3!,sigmoidNorm!

    export getRandIndices,
           getNMI,
           getVmeasure,
           getVarInfo,
           getJaccardSimilarity,
           time_invariant_ari,
           time_invariant_nmi,
           time_invariant_vmeasure,
           time_invariant_jaccard,
           time_invariant_varinfo,
           calc_time_invariant_ARI_summarization,
           calc_time_variant_ARI_summarization,
           calc_time_invariant_NMI_summarization,
           calc_time_variant_NMI_summarization,
           calc_time_invariant_Vmeasure_summarization,
           calc_time_variant_Vmeasure_summarization,
           calc_time_invariant_VarInfo_summarization,
           calc_time_variant_VarInfo_summarization,
           calc_time_invariant_Jaccard_summarization,
           calc_time_variant_Jaccard_summarization,
           calc_time_invariant_CVI_summarization,
           setup_metrics_list


    export  variational_inference,
           depracated_variational_inference_notusingXhat,
           variational_inference_HDP,
           variational_inference_dynamicHDP,
           tidy_variational_inference_dynamicHDP,
           tidy_variational_inference_dynamicHDP_SparseVS,
           tidy_variational_inference_dynamicHDP_VS1,
           tidy_variational_inference_dynamicHDP_VS2,
   
           variational_inference_dynamicHDP_vs25_fast3,
           variational_inference_dynamicHDP_vs25_fast3_mtall,
           variational_inference_dynamicHDP_vs25_fast3_mtbest,
           variational_inference_dynamicHDP_vs25_fast3_mtbest_sparserestart,
           variational_inference_dynamicHDP_vshoff,
           variational_inference_dynamicHDP_vshoff_perK,
           variational_inference_dynamicHDP_vshoff_mpu,
           variational_inference_dynamicHDP_vshoff_lowmem_mpu,
           variational_inference_dynamicHDP_vshoff2,
           extract_cluster_paramter,
           extract_condition_paramter,
           extract_gene_paramter,
           extract_rtik_paramter,
           extract_elbo_vals_perK,
           extract_and_add_parameters_to_outputs_dict!,
   
           #Functions that calculate parts of the elbo
           calc_DataElbo,
           calc_Hz,
           calc_SurragateLowerBound_unconstrained,
           calc_SurragateLowerBound,
           calc_Hs,
           calc_wAllocationsLowerBound,
           calc_GammaElbo,
           calc_alphaElbo,
           calc_ImportanceElbo,
           calc_Hv,
           calc_DataElbo7,
           calc_DataElbo12,
   
   
   
           calc_DataElbo25_fast3,
           calc_Hz_fast3,
           calc_HyjkSurragateLowerBound_unconstrained,
           calc_wAllocationsLowerBound_fast3,
           calc_alphaElbo_fast3,
           calc_HsGammaAlphaElbo_fast3,
           calc_HsElbo,
           calculate_elbo,
           calculate_elbo_perK,
           calc_SurragateLowerBound_unconstrained_elbo,
           calc_DataElbo_perK,
           calculate_elbo_mpu,
           calc_DataElbo_mpu,
   
           #Math Util function
           c_Ga,
           c_Beta,
   
           #Variational Distribution Updates
           update_rtik_mpu!,
           update_Ntk_mpu!,
           update_c_ttprime_mpu!,
           update_d_hat_mpu!,
           update_d_hat_sum_mpu!,
           update_Nk_mpu!,
           update_x_hat_k_mpu!,
           update_x_hat_sq_k_mpu!,
           update_mk_hat_mpu!,
           update_v_sq_k_hat_mpu!,
           update_yjk_mpu!,
           update_var_muk_hat_mpu!,
           update_κk_hat_mpu!,
           update_σ_sq_k_hat_mpu!,
           update_λ_sq_hat_mpu!,
           update_st_hat_mpu!,
           update_Tk_mpu!,
           update_gh_hat_mpu!,
           update_ηk!,
   
   
           #Expected value functions
           βk_expected_value,
           uk_expected_value,
           logUk_expected_value,
           log1minusUk_expected_value,
           log_π_expected_value,
           log_τ_kj_expected_value,
           log_τ_k_expected_value,
           τ_μ_expected_value,
   
           αt_expected_value,
           γ_expected_value,
           log_γ_expected_value,
           log_αt_expected_value,
           log_w_ttprime_expected_value,
           log_tilde_wt_expected_value,
           log_minus_tilde_wt_expected_value,
   
           log_τ_kj_error_expected_value,
           log_τ_k_error_expected_value,
           τ_μ_error_expected_value,
   
           adjust_e_log_π_tk3!,
           log_π_expected_value_fast3!,
           expectation_βk,
           recursive_minus_e_uk_cumprod,
           expectation_log_normal_l_j!,
           expectation_log_π_tk,
           expectation_log_tilde_wtt,
           expectation_log_minus_tilde_wtt,
           expectation_uk,
           expectation_αt,
           expectation_log_αt,
           expectation_logUk,
           expectation_log1minusUk,
   
   
           #Intializations functions
           init_params_genes,
           init_params_states,
           init_θ_hat_tk,
           init_ηtkj_prior,
           
           init_mk_hat!,
           init_λ_sq_vec!,
           init_σ_sq_k_vec!,
           init_v_sq_k_hat_vec!,
           init_ghk_hat_vec!,
           init_c_ttprime_hat_vec!,
           init_d_hat_vec!,
           init_st_hat_vec!,
           init_yjk_vec!,
           init_rtik_vec!,
           init_m_err_hat!,
           init_λ0_err_hat_vec!,
           init_a0_err_hat_vec!,
           init_b0_err_hat_vec!,
           initialize_VariationalInference_types!,
           low_memory_initialization,
   
           #Surragate Lower Bound optimzation functions
           #from viSurragateHdpUpdates.jls
           SurragateLowerBound_util,
           SurragateLowerBound_unconstrained_util,
           g_constrained!,
           g_unconstrained!,
           genterate_Delta_mk,
   
           #Closures for Surragate Lower Bound optimzation
           #from viSurragateHdpUpdates.jl
           g_constrained_closure!,
           g_unconstrained_closure!,
           SurragateLowerBound_closure,
           SurragateLowerBound_unconstrained_closure,
   
           Features,
           CellFeatures,
           NullDistributionFeatures,
           CellClusterLogLikelihoodFeatures,
           ClusterFeatures,
           GeneFeatures,
           ConditionFeatures,
           DataFeatures,
           ModelParameterFeatures,
           ElboFeatures,
           get_timeranges,
           _reset!

    include(curr_dir*src_dir*"processing.jl")
    include(curr_dir*src_dir*"math.jl")
    include(curr_dir*src_dir*"modelMetrics.jl")
    include(curr_dir*src_dir*"viCoordinateAscent.jl")
    include(curr_dir*src_dir*"viCustomType.jl")
    include(curr_dir*src_dir*"viElboCalculations.jl")
    include(curr_dir*src_dir*"viExpectations.jl")
    include(curr_dir*src_dir*"viInitializations.jl")
    include(curr_dir*src_dir*"viSurragateHdpUpdates.jl")
    include(curr_dir*src_dir*"viVariationalUpdates.jl")
end
