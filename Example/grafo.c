//
//  grafo.m
//  Zoorocaba
//
//  Created by William Alvelos on 18/03/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//


#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <math.h>
#include "grafo.h"


#define AX -23.669329
#define AY -46.701016
#define BX -23.669241
#define BY -46.700534
#define CX -23.670177
#define CY -46.698888
#define DX -23.668993
#define DY -46.700067
#define EX -23.669719
#define EY -46.698213



typedef struct {
    int vertex;
    int weight;
} edge_t;

typedef struct{
    double x;
    double y;
    char letra;
} coordenada;

typedef struct {
    edge_t **edges;
    int edges_len;
    int edges_size;
    int dist;
    int prev;
    int visited;
} vertex_t;

typedef struct {
    vertex_t **vertices;
    int vertices_len;
    int vertices_size;
} graph_t;

typedef struct {
    int *data;
    int *prio;
    int *index;
    int len;
    int size;
} heap_t;

void add_vertex (graph_t *g, int i) {
    if (g->vertices_size < i + 1) {
        int size = g->vertices_size * 2 > i ? g->vertices_size * 2 : i + 4;
        g->vertices = realloc(g->vertices, size * sizeof (vertex_t *));
        for (int j = g->vertices_size; j < size; j++)
            g->vertices[j] = NULL;
        g->vertices_size = size;
    }
    if (!g->vertices[i]) {
        g->vertices[i] = calloc(1, sizeof (vertex_t));
        g->vertices_len++;
    }
}

void add_edge (graph_t *g, int a, int b, int w) {
    a = a - 'a';
    b = b - 'a';
    add_vertex(g, a);
    add_vertex(g, b);
    vertex_t *v = g->vertices[a];
    if (v->edges_len >= v->edges_size) {
        v->edges_size = v->edges_size ? v->edges_size * 2 : 4;
        v->edges = realloc(v->edges, v->edges_size * sizeof (edge_t *));
    }
    edge_t *e = calloc(1, sizeof (edge_t));
    e->vertex = b;
    e->weight = w;
    v->edges[v->edges_len++] = e;
}

heap_t *create_heap (int n) {
    heap_t *h = calloc(1, sizeof (heap_t));
    h->data = calloc(n + 1, sizeof (int));
    h->prio = calloc(n + 1, sizeof (int));
    h->index = calloc(n, sizeof (int));
    return h;
}

void push_heap (heap_t *h, int v, int p) {
    int i = h->index[v] || ++h->len;
    int j = i / 2;
    while (i > 1) {
        if (h->prio[j] < p)
            break;
        h->data[i] = h->data[j];
        h->prio[i] = h->prio[j];
        h->index[h->data[i]] = i;
        i = j;
        j = j / 2;
    }
    h->data[i] = v;
    h->prio[i] = p;
    h->index[v] = i;
}

int min (heap_t *h, int i, int j, int k) {
    int m = i;
    if (j <= h->len && h->prio[j] < h->prio[m])
        m = j;
    if (k <= h->len && h->prio[k] < h->prio[m])
        m = k;
    return m;
}

int pop_heap (heap_t *h) {
    int v = h->data[1];
    h->data[1] = h->data[h->len];
    h->prio[1] = h->prio[h->len];
    h->index[h->data[1]] = 1;
    h->len--;
    int i = 1;
    while (1) {
        int j = min(h, i, 2 * i, 2 * i + 1);
        if (j == i)
            break;
        h->data[i] = h->data[j];
        h->prio[i] = h->prio[j];
        h->index[h->data[i]] = i;
        i = j;
    }
    h->data[i] = h->data[h->len + 1];
    h->prio[i] = h->prio[h->len + 1];
    h->index[h->data[i]] = i;
    return v;
}

void dijkstra (graph_t *g, int a, int b) {
    
    int i, j;
    a = a - 'a';
    b = b - 'a';
    for (i = 0; i < g->vertices_len; i++) {
        vertex_t *v = g->vertices[i];
        v->dist = INT_MAX;
        v->prev = 0;
        v->visited = 0;
    }
    
    vertex_t *v = g->vertices[a];
    
    v->dist = 0;
    heap_t *h = create_heap(g->vertices_len);
    push_heap(h, a, v->dist);
    while (h->len) {
        i = pop_heap(h);
        if (i == b)
            break;
        v = g->vertices[i];
        v->visited = 1;
        for (j = 0; j < v->edges_len; j++) {
            edge_t *e = v->edges[j];
            vertex_t *u = g->vertices[e->vertex];
            if (!u->visited && v->dist + e->weight <= u->dist) {
                u->prev = i;
                u->dist = v->dist + e->weight;
                push_heap(h, e->vertex, u->dist);
            }
        }
    }
}

int print_path (graph_t *g, int i) {
    int n, j;
    vertex_t *v, *u;
    i = i - 'a';
    v = g->vertices[i];
    if (v->dist == INT_MAX) {
        printf("no path\n");
        return;
    }
    for (n = 1, u = v; u->dist; u = g->vertices[u->prev], n++)
        ;
    char *path = malloc(n);
    path[n - 1] = 'a' + i;
    for (j = 0, u = v; u->dist; u = g->vertices[u->prev], j++)
        path[n - j - 2] = 'a' + u->prev;
    
    printf("%d %.*s\n", v->dist, n, path);
    
    return path[1];
}


int principal(){
    graph_t *g = calloc(1, sizeof (graph_t));
    add_edge(g, 'a', 'b', 7);
    add_edge(g, 'a', 'c', 9);
    add_edge(g, 'a', 'f', 14);
    add_edge(g, 'b', 'c', 10);
    add_edge(g, 'b', 'd', 15);
    add_edge(g, 'c', 'd', 11);
    add_edge(g, 'c', 'f', 2);
    add_edge(g, 'd', 'e', 6);
    add_edge(g, 'e', 'f', 9);
    dijkstra(g, 'a', 'e');
    print_path(g, 'c');
    return 0;
}


int minimo(int x, int y){
    int r = y ^ ((x ^ y) & -(x < y)); // min(x, y)
    return r;
}


int aproxima(float x, float y, float matrix[4][3]){
    
    float minimo2 = -1;
    int proximo = -1;
    
    for(int i = 0 ; i < 3 ; i++){
        
        float valor = sqrt((matrix[i][1] - x) * (matrix[i][1] - x) + (matrix[i][2] - y) * (matrix[i][2] - y));
        
        if(valor < minimo2 || minimo2 == -1.0000){
            minimo2 = valor;
            proximo = i + 1;
        }
        
    }
    
    
    return proximo;
}


double distancia(coordenada a, coordenada b){
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.x, 2));
}

int GetInt(float x, float y, int j, int localAnimal){
    int i;
    
    coordenada a[10];
    
    //a
    a[0].x = -23.669329;
    a[0].y = -46.701016;
    a[0].letra = 'a';
    //b
    a[1].x = -23.669241;
    a[1].y = -46.700534;
    a[1].letra = 'b';
    //c
    a[2].x = -23.668993;
    a[2].y = -46.700067;
    a[2].letra = 'c';
    //d
    a[3].x = -23.670177;
    a[3].y = -46.698888;
    a[3].letra = 'd';
    //e
    a[4].x = -23.669719;
    a[4].y = -46.698213;
    a[4].letra = 'e';

//    float matrix[4][3] = { {1.0, CX, CY},
//                          {2.0, BX, BY},
//                          {3.0, AX, AY},
//                          {4.0, DX, DY}};
//    
//    
//    printf("x = %lf, y = %lf\n", x, y);
//    int w = aproxima(x, y, matrix);
//    printf("%d\n", w);
    
    graph_t *g = calloc(1, sizeof (graph_t));
    
    char string[30];
    //e coloca as vertices
    add_edge(g, a[0].letra, a[1].letra, distancia(a[0], a[1]));
    add_edge(g, a[1].letra, a[2].letra, distancia(a[1], a[2]));
    add_edge(g, a[2].letra, a[3].letra, distancia(a[2], a[3]));
    add_edge(g, a[3].letra, a[4].letra, distancia(a[3], a[4]));
    
//    dijkstra(g, j+97, 'e');
    j += 93;
    char c = (char)j;
    char local = (char)localAnimal;
        
    dijkstra(g, c, local);
    int valor = print_path(g, local);

    return valor;
}

