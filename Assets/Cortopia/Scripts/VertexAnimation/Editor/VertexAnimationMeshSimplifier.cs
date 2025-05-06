// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Rendering;

namespace Cortopia.Scripts.VertexAnimation.Editor
{
    public static class VertexAnimationMeshSimplifier
    {
        public static Mesh Simplify(this Mesh mesh, float quality)
        {
            string name = mesh.name;

            var triangles = mesh.ToTriangles();

            int targetCount = Mathf.FloorToInt(triangles.Count * quality);
            int loopCount = 0;

            while (triangles.Count > targetCount)
            {
                // Sort by perimeter.
                // TODO: Better priority system. Maybe allow user to pass in method.
                if (loopCount % triangles.Count == 0)
                {
                    triangles.SortByPerimeter();
                }

                // Select tri/vert to simplify.
                const int curTriIndex = 0;
                // TODO: Select vert by shortest total distance to the two other verts in the triangle.
                const int curVertIndex = 0;
                Vector3 curVert = triangles[curTriIndex].Vertices[curVertIndex];

                // Select closest vert within triangle to merge into.
                int newVertIndex = triangles[curTriIndex].GetClosestVertexIndex(curVert);

                // Update all triangles.
                // TODO: Apply only to connected triangles.
                foreach (Triangle triangle in triangles)
                {
                    triangle.UpdateVertex(triangles[curTriIndex], curVertIndex, newVertIndex);
                }

                triangles[curTriIndex].UpdateVertex(curVertIndex, newVertIndex);

                // Remove all zero triangles.
                triangles.RemoveAll(t => t.IsZero());

                loopCount++;
            }

            mesh.Clear();
            mesh = triangles.ToMesh();
            mesh.name = name;

            return mesh;
        }

        public static List<Triangle> ToTriangles(this Mesh mesh)
        {
            var triangles = new List<Triangle>();

            var verts = mesh.vertices;
            var normals = mesh.normals;
            int[] tris = mesh.triangles;

            var uvs = new Dictionary<int, List<Vector2>>();
            for (int u = 0; u < 8; u++)
            {
                var coordinates = new List<Vector2>();
                mesh.GetUVs(u, coordinates);

                if (coordinates.Any())
                {
                    uvs.Add(u, coordinates);
                }
            }

            for (int t = 0; t < tris.Length; t += 3)
            {
                var tri = new Triangle
                {
                    Vertices = {[0] = verts[tris[t + 0]], [1] = verts[tris[t + 1]], [2] = verts[tris[t + 2]]},
                    Normals = {[0] = normals[tris[t + 0]], [1] = normals[tris[t + 1]], [2] = normals[tris[t + 2]]}
                };

                foreach (var uv in uvs)
                {
                    if (tri.Uvs.TryGetValue(uv.Key, out var coordinates))
                    {
                        coordinates.Add(uv.Value[tris[t + 0]]);
                        coordinates.Add(uv.Value[tris[t + 1]]);
                        coordinates.Add(uv.Value[tris[t + 2]]);
                    }
                    else
                    {
                        tri.Uvs.Add(uv.Key, new List<Vector2> {uv.Value[tris[t + 0]], uv.Value[tris[t + 1]], uv.Value[tris[t + 2]]});
                    }
                }

                triangles.Add(tri);
            }

            return triangles;
        }

        public static Mesh ToMesh(this List<Triangle> triangles)
        {
            var mesh = new Mesh();
            mesh.Clear();

            var vertices = new List<Vector3>(triangles.Count * 3);
            var normals = new List<Vector3>(triangles.Count * 3);
            var tris = new List<int>(triangles.Count * 3);
            var uvs = new Dictionary<int, List<Vector2>>();

            int skipped = 0;
            for (int t = 0; t < triangles.Count; t++)
            {
                for (int v = 0; v < triangles[t].Vertices.Length; v++)
                {
                    // Check for existing matching vert.
                    int vIndex = vertices.IndexOf(triangles[t].Vertices[v]);
                    if (vIndex != -1)
                    {
                        // Check for existing matching normal.
                        if (normals[vIndex] == triangles[t].Normals[v])
                        {
                            // We have a duplicate.
                            // Don't add the data and instead point to existing.
                            tris.Add(vIndex);
                            skipped++;
                            continue;
                        }
                    }

                    // Add data when it doesn't exist.
                    vertices.Add(triangles[t].Vertices[v]);
                    normals.Add(triangles[t].Normals[v]);

                    foreach (var uv in triangles[t].Uvs)
                    {
                        if (uvs.TryGetValue(uv.Key, out var coordinates))
                        {
                            coordinates.Add(uv.Value[v]);
                        }
                        else
                        {
                            uvs.Add(uv.Key, new List<Vector2> {uv.Value[v]});
                        }
                    }

                    tris.Add(t * 3 + v - skipped);
                }
            }

            // Large mesh support.
            if (vertices.Count > 65535)
            {
                mesh.indexFormat = IndexFormat.UInt32;
            }

            mesh.vertices = vertices.ToArray();
            mesh.normals = normals.ToArray();

            foreach (var uv in uvs)
            {
                mesh.SetUVs(uv.Key, uv.Value);
            }

            mesh.triangles = tris.ToArray();

            mesh.Optimize();
            mesh.RecalculateBounds();
            mesh.RecalculateTangents();

            return mesh;
        }

        public static List<Triangle> SortByPerimeter(this List<Triangle> triangles)
        {
            triangles.Sort((x, y) => x.Perimeter().CompareTo(y.Perimeter()));

            return triangles;
        }
        // Convert mesh into Triangles.
        // Change triangles.
        // Generate new mesh data based on Triangles.

        // Everything is basically done through the triangle.
        // When something changes in the triangle all correlated sub data changes as well (uv, normals, verts, etc).

        public class Triangle
        {
            public readonly Vector3[] Normals = new Vector3[3];
            public readonly Dictionary<int, List<Vector2>> Uvs = new();
            // Vertices (Vector3)
            // Normals (Vector3)
            // UVs (UV0, UV1, ..., UV7)
            // Other...

            public readonly Vector3[] Vertices = new Vector3[3];

            public float Perimeter()
            {
                return Vector3.Distance(this.Vertices[0], this.Vertices[1]) + Vector3.Distance(this.Vertices[1], this.Vertices[2]) +
                       Vector3.Distance(this.Vertices[2], this.Vertices[0]);
            }

            // If two or more points have the same values the triangle has no surface area and will be 'zero'.
            public bool IsZero()
            {
                return this.Vertices[0] == this.Vertices[1] || this.Vertices[0] == this.Vertices[2] || this.Vertices[1] == this.Vertices[2];
            }

            // Returns the closest vertex index of a vertex within this triangle.
            public int GetClosestVertexIndex(Vector3 vertex)
            {
                float distance = Mathf.Infinity;
                int closestVertex = -1;

                for (int v = 0; v < this.Vertices.Length; v++)
                {
                    if (this.Vertices[v] == vertex)
                    {
                        continue;
                    }

                    float dist = Vector3.Distance(this.Vertices[v], vertex);

                    if (!(dist < distance))
                    {
                        continue;
                    }

                    distance = dist;
                    closestVertex = v;
                }

                return closestVertex;
            }

            // Update triangle by copying data from a point in this triangle.
            public bool UpdateVertex(int curVertexIndex, int newVertexIndex)
            {
                this.Vertices[curVertexIndex] = this.Vertices[newVertexIndex];
                this.Normals[curVertexIndex] = this.Normals[newVertexIndex];

                foreach (var uv in this.Uvs)
                {
                    uv.Value[curVertexIndex] = uv.Value[newVertexIndex];
                }

                return true;
            }

            // Update triangle by copying data from an other triangle.
            public bool UpdateVertex(Triangle sourceTriangle, int sourceVertexIndex, int newSourceVertexIndex)
            {
                if (sourceTriangle == this)
                {
                    return false;
                }

                Vector3 sourceVertex = sourceTriangle.Vertices[sourceVertexIndex];
                int index = Array.IndexOf(this.Vertices, sourceVertex);

                if (index == -1)
                {
                    return false;
                }

                // Set all the new data.
                this.Vertices[index] = sourceTriangle.Vertices[newSourceVertexIndex];
                this.Normals[index] = sourceTriangle.Normals[newSourceVertexIndex];

                foreach (var uv in this.Uvs)
                {
                    uv.Value[index] = sourceTriangle.Uvs[uv.Key][newSourceVertexIndex];
                }

                return true;
            }
        }
    }
}