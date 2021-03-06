#' Reorder a Matrix Based on Hierarchical Clustering
#' 
#' Reorder matrix rows, columns, or both via hierarchical clustering.
#' 
#' @param x A matrix.
#' @param dim The dimension to reorder (cluster); must be set to "row", "col", 
#' or "both".
#' @param method The agglomeration method to be used (see \code{\link[stats]{hclust}}).
#' @param \ldots ignored.
#' @return Returns a reordered matrix.
#' @export
#' @seealso \code{\link[stats]{hclust}}
#' @examples
#' cluster_matrix(mtcars)
#' cluster_matrix(mtcars, dim = 'row')
#' cluster_matrix(mtcars, dim = 'col')
#' 
#' \dontrun{
#' if (!require("pacman")) install.packages("pacman")
#' pacman::p_load(tidyverse, viridis, gridExtra)
#' 
#' ## plot heatmap w/o clustering
#' wo <- mtcars %>%
#'     cor() %>%
#'     tidy_matrix('car', 'var') %>%
#'     ggplot(aes(var, car, fill = value)) +
#'          geom_tile() +
#'          scale_fill_viridis(name = expression(r[xy])) +
#'          theme(
#'              axis.text.y = element_text(size = 8)   ,
#'              axis.text.x = element_text(size = 8, hjust = 1, vjust = 1, angle = 45),   
#'              legend.position = 'bottom',
#'              legend.key.height = grid::unit(.1, 'cm'),
#'              legend.key.width = grid::unit(.5, 'cm')
#'          ) +
#'          labs(subtitle = "With Out Clustering")
#' 
#' ## plot heatmap w clustering
#' w <- mtcars %>%
#'     cor() %>%
#'     cluster_matrix() %>%
#'     tidy_matrix('car', 'var') %>%
#'     mutate(
#'         var = factor(var, levels = unique(var)),
#'         car = factor(car, levels = unique(car))        
#'     ) %>%
#'     group_by(var) %>%
#'     ggplot(aes(var, car, fill = value)) +
#'          geom_tile() +
#'          scale_fill_viridis(name = expression(r[xy])) +
#'          theme(
#'              axis.text.y = element_text(size = 8)   ,
#'              axis.text.x = element_text(size = 8, hjust = 1, vjust = 1, angle = 45),   
#'              legend.position = 'bottom',
#'              legend.key.height = grid::unit(.1, 'cm'),
#'              legend.key.width = grid::unit(.5, 'cm')               
#'          ) +
#'          labs(subtitle = "With Clustering")
#' 
#' gridExtra::grid.arrange(wo, w, ncol = 2)
#' }
cluster_matrix <- function(x, dim = 'both', method = "ward.D2", ...){
    
    stopifnot(is.matrix(x) | is.data.frame(x))
    
    switch(dim,
        row = {
                hc1 <- stats::hclust(stats::dist(x), method = method)
                x[hc1$order, ]
            },
        col = {
                hc2 <- stats::hclust(stats::dist(t(x)), method = method)
                x[, hc2$order]
            },
        both = {
                hc1 <- stats::hclust(stats::dist(x), method = method)
                hc2 <- stats::hclust(stats::dist(t(x)), method = method)
                x[hc1$order, hc2$order]
        },
        stop('`dim` must be set to "row", "col", or "both"')
    )
    
}



